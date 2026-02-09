/**
 * OpenShelf Cloud Functions
 *
 * This file contains serverless backend functions for the OpenShelf app.
 * Functions can be triggered by:
 * - HTTP calls from Flutter (callable functions)
 * - Firestore events (onCreate, onUpdate, onDelete)
 * - Authentication events
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

// ===========================
// CALLABLE CLOUD FUNCTIONS
// ===========================

/**
 * Callable Function: Say Hello
 *
 * This function can be called directly from Flutter.
 * It accepts a name parameter and returns a personalized greeting.
 *
 * Usage from Flutter:
 * final callable = FirebaseFunctions.instance.httpsCallable('sayHello');
 * final result = await callable.call({'name': 'Alex'});
 * print(result.data['message']);
 */
exports.sayHello = functions.https.onCall((data, context) => {
  // Extract name from request data, default to "User" if not provided
  const name = data.name || "User";

  // Log the function call for monitoring
  console.log(`sayHello function called with name: ${name}`);

  // Return personalized greeting
  return {
    message: `Hello, ${name}! Welcome to OpenShelf 📚`,
    timestamp: new Date().toISOString(),
    userId: context.auth ? context.auth.uid : "anonymous",
  };
});

/**
 * Callable Function: Add Book Recommendation
 *
 * This function processes a book addition request from Flutter.
 * It validates the input, adds metadata, and stores it in Firestore.
 *
 * Usage from Flutter:
 * final callable = FirebaseFunctions.instance.httpsCallable('addBookRecommendation');
 * final result = await callable.call({
 *   'title': 'Clean Code',
 *   'author': 'Robert C. Martin',
 *   'genre': 'Programming'
 * });
 */
exports.addBookRecommendation = functions.https.onCall(
  async (data, context) => {
    // Check if user is authenticated
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated to add recommendations",
      );
    }

    // Validate input data
    const { title, author, genre } = data;

    if (!title || !author) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Title and author are required",
      );
    }

    try {
      // Create book document with metadata
      const bookData = {
        title: title,
        author: author,
        genre: genre || "General",
        recommendedBy: context.auth.uid,
        recommendedAt: admin.firestore.FieldValue.serverTimestamp(),
        status: "pending",
        likes: 0,
      };

      // Add to Firestore
      const docRef = await admin
        .firestore()
        .collection("recommendations")
        .add(bookData);

      console.log(
        `Book recommendation added: ${docRef.id} by user ${context.auth.uid}`,
      );

      return {
        success: true,
        bookId: docRef.id,
        message: "Book recommendation added successfully!",
      };
    } catch (error) {
      console.error("Error adding book recommendation:", error);
      throw new functions.https.HttpsError(
        "internal",
        "Failed to add book recommendation",
      );
    }
  },
);

// ===========================
// FIRESTORE TRIGGER FUNCTIONS
// ===========================

/**
 * Firestore Trigger: New User Created
 *
 * This function runs automatically when a new user document is created.
 * It initializes user profile data and sends a welcome notification.
 *
 * Triggered by: Creating a document in the "users" collection
 */
exports.onUserCreated = functions.firestore
  .document("users/{userId}")
  .onCreate(async (snap, context) => {
    const userData = snap.data();
    const userId = context.params.userId;

    console.log(`New user created: ${userId}`, userData);

    try {
      // Initialize user statistics
      await admin.firestore().collection("users").doc(userId).update({
        booksRead: 0,
        booksShared: 0,
        joinedAt: admin.firestore.FieldValue.serverTimestamp(),
        isActive: true,
      });

      // Create a welcome notification
      await admin
        .firestore()
        .collection("notifications")
        .add({
          userId: userId,
          type: "welcome",
          title: "Welcome to OpenShelf! 📚",
          message: `Hi ${userData.displayName || "there"}! Start exploring books and connect with fellow readers.`,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          read: false,
        });

      console.log(`User profile initialized for ${userId}`);
      return null;
    } catch (error) {
      console.error(`Error initializing user profile for ${userId}:`, error);
      return null;
    }
  });

/**
 * Firestore Trigger: Book Status Changed
 *
 * This function runs when a book document is updated.
 * It tracks status changes and updates analytics.
 *
 * Triggered by: Updating a document in the "books" collection
 */
exports.onBookUpdated = functions.firestore
  .document("books/{bookId}")
  .onUpdate(async (change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();
    const bookId = context.params.bookId;

    // Check if status changed
    if (beforeData.status !== afterData.status) {
      console.log(
        `Book ${bookId} status changed from ${beforeData.status} to ${afterData.status}`,
      );

      // Update analytics
      try {
        const analyticsRef = admin
          .firestore()
          .collection("analytics")
          .doc("books");

        await analyticsRef.set(
          {
            [`statusChanges.${afterData.status}`]:
              admin.firestore.FieldValue.increment(1),
            lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
          },
          { merge: true },
        );

        // If book is marked as "read", increment user's books read count
        if (afterData.status === "read" && afterData.userId) {
          await admin
            .firestore()
            .collection("users")
            .doc(afterData.userId)
            .update({
              booksRead: admin.firestore.FieldValue.increment(1),
            });
        }

        console.log(`Analytics updated for book status change: ${bookId}`);
      } catch (error) {
        console.error("Error updating analytics:", error);
      }
    }

    return null;
  });

/**
 * Firestore Trigger: Book Deleted
 *
 * This function runs when a book is deleted.
 * It performs cleanup operations like deleting related reviews.
 *
 * Triggered by: Deleting a document in the "books" collection
 */
exports.onBookDeleted = functions.firestore
  .document("books/{bookId}")
  .onDelete(async (snap, context) => {
    const bookId = context.params.bookId;
    const bookData = snap.data();

    console.log(`Book deleted: ${bookId} - ${bookData.title}`);

    try {
      // Delete all reviews for this book
      const reviewsSnapshot = await admin
        .firestore()
        .collection("reviews")
        .where("bookId", "==", bookId)
        .get();

      const batch = admin.firestore().batch();
      reviewsSnapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });

      await batch.commit();
      console.log(`Deleted ${reviewsSnapshot.size} reviews for book ${bookId}`);

      return null;
    } catch (error) {
      console.error(`Error cleaning up book ${bookId}:`, error);
      return null;
    }
  });

// ===========================
// SCHEDULED FUNCTIONS (Optional)
// ===========================

/**
 * Scheduled Function: Daily Stats Update
 *
 * This function runs daily to aggregate statistics.
 * Uncomment to enable scheduled execution.
 *
 * Schedule: Every day at midnight (UTC)
 */
/*
exports.dailyStatsUpdate = functions.pubsub
  .schedule("0 0 * * *")
  .timeZone("UTC")
  .onRun(async (context) => {
    console.log("Running daily stats update...");
    
    try {
      // Get total books count
      const booksSnapshot = await admin.firestore()
        .collection("books")
        .get();
      
      // Get total users count
      const usersSnapshot = await admin.firestore()
        .collection("users")
        .get();
      
      // Update daily stats document
      await admin.firestore()
        .collection("analytics")
        .doc("daily")
        .set({
          totalBooks: booksSnapshot.size,
          totalUsers: usersSnapshot.size,
          updatedAt: admin.firestore.FieldValue.serverTimestamp()
        });
      
      console.log("Daily stats updated successfully");
      return null;
    } catch (error) {
      console.error("Error updating daily stats:", error);
      return null;
    }
  });
*/
