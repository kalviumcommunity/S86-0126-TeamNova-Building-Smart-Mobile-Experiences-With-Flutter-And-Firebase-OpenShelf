# Cloud Functions Implementation - OpenShelf

## 📚 Overview

This implementation demonstrates **Firebase Cloud Functions** integration in the OpenShelf app. Cloud Functions provide serverless backend capabilities that execute automatically in response to events or HTTP requests, eliminating the need to manage servers.

## 🎯 What We Built

### 1. **Callable Cloud Functions**

Functions that can be invoked directly from Flutter:

#### `sayHello` Function

A simple callable function that returns a personalized greeting.

**Backend Code** (`functions/index.js`):

```javascript
exports.sayHello = functions.https.onCall((data, context) => {
  const name = data.name || "User";
  console.log(`sayHello function called with name: ${name}`);

  return {
    message: `Hello, ${name}! Welcome to OpenShelf 📚`,
    timestamp: new Date().toISOString(),
    userId: context.auth ? context.auth.uid : "anonymous",
  };
});
```

**Flutter Integration**:

```dart
final callable = FirebaseFunctions.instance.httpsCallable('sayHello');
final result = await callable.call({'name': 'Alex'});
print(result.data['message']); // "Hello, Alex! Welcome to OpenShelf 📚"
```

#### `addBookRecommendation` Function

A more complex function that validates input, adds metadata, and stores data in Firestore.

**Backend Code**:

```javascript
exports.addBookRecommendation = functions.https.onCall(
  async (data, context) => {
    // Authentication check
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated to add recommendations",
      );
    }

    // Input validation
    const { title, author, genre } = data;
    if (!title || !author) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Title and author are required",
      );
    }

    // Add to Firestore with metadata
    const bookData = {
      title: title,
      author: author,
      genre: genre || "General",
      recommendedBy: context.auth.uid,
      recommendedAt: admin.firestore.FieldValue.serverTimestamp(),
      status: "pending",
      likes: 0,
    };

    const docRef = await admin
      .firestore()
      .collection("recommendations")
      .add(bookData);

    return {
      success: true,
      bookId: docRef.id,
      message: "Book recommendation added successfully!",
    };
  },
);
```

**Flutter Integration**:

```dart
final result = await CloudFunctionsService().addBookRecommendation(
  title: 'Clean Code',
  author: 'Robert C. Martin',
  genre: 'Programming',
);
print(result['bookId']); // Firestore document ID
```

### 2. **Event-Based Cloud Functions**

Functions that trigger automatically on Firestore events:

#### `onUserCreated` - Firestore Trigger

Runs when a new user document is created.

```javascript
exports.onUserCreated = functions.firestore
  .document("users/{userId}")
  .onCreate(async (snap, context) => {
    const userData = snap.data();
    const userId = context.params.userId;

    // Initialize user statistics
    await admin.firestore().collection("users").doc(userId).update({
      booksRead: 0,
      booksShared: 0,
      joinedAt: admin.firestore.FieldValue.serverTimestamp(),
      isActive: true,
    });

    // Create welcome notification
    await admin
      .firestore()
      .collection("notifications")
      .add({
        userId: userId,
        type: "welcome",
        title: "Welcome to OpenShelf! 📚",
        message: `Hi ${userData.displayName}! Start exploring books.`,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        read: false,
      });

    return null;
  });
```

**Use Cases**:

- Auto-initialize user profiles
- Send welcome notifications
- Set up default preferences

#### `onBookUpdated` - Update Trigger

Tracks changes to book status and updates analytics.

```javascript
exports.onBookUpdated = functions.firestore
  .document("books/{bookId}")
  .onUpdate(async (change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();

    // Check if status changed
    if (beforeData.status !== afterData.status) {
      // Update analytics
      await analyticsRef.set(
        {
          [`statusChanges.${afterData.status}`]:
            admin.firestore.FieldValue.increment(1),
          lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true },
      );

      // Increment user's books read count
      if (afterData.status === "read" && afterData.userId) {
        await admin
          .firestore()
          .collection("users")
          .doc(afterData.userId)
          .update({
            booksRead: admin.firestore.FieldValue.increment(1),
          });
      }
    }
    return null;
  });
```

#### `onBookDeleted` - Delete Trigger

Performs cleanup when a book is deleted.

```javascript
exports.onBookDeleted = functions.firestore
  .document("books/{bookId}")
  .onDelete(async (snap, context) => {
    const bookId = context.params.bookId;

    // Delete all related reviews
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
    return null;
  });
```

## 🏗️ Project Structure

```
openshelf_app/
├── functions/                      # Cloud Functions backend
│   ├── index.js                   # Function definitions
│   ├── package.json               # Node.js dependencies
│   └── .gitignore                # Ignore node_modules
├── lib/
│   ├── services/
│   │   └── cloud_functions_service.dart  # Flutter service class
│   └── screens/
│       └── cloud_functions_demo_screen.dart  # UI demo
├── firebase.json                  # Firebase config (includes functions)
└── pubspec.yaml                   # Added cloud_functions dependency
```

## 📦 Dependencies Added

**pubspec.yaml**:

```yaml
dependencies:
  cloud_functions: ^5.0.0
```

**functions/package.json**:

```json
{
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^5.0.0"
  }
}
```

## 🚀 Setup Instructions

### 1. Install Firebase Tools (if not already installed)

```bash
npm install -g firebase-tools
```

### 2. Login to Firebase

```bash
firebase login
```

### 3. Install Function Dependencies

```bash
cd openshelf_app/functions
npm install
```

### 4. Deploy Functions to Firebase

```bash
firebase deploy --only functions
```

Expected output:

```
✔ functions[sayHello]: Successful create operation.
✔ functions[addBookRecommendation]: Successful create operation.
✔ functions[onUserCreated]: Successful create operation.
✔ functions[onBookUpdated]: Successful create operation.
✔ functions[onBookDeleted]: Successful create operation.
```

### 5. Get Flutter Dependencies

```bash
cd ..
flutter pub get
```

### 6. Run the App

```bash
flutter run
```

## 🧪 Testing the Functions

### Test Callable Functions

1. Open the Cloud Functions Demo screen in the app
2. Enter your name and click "Call sayHello()"
3. View the response message in the UI

### Test Event-Based Functions

1. Create a new user document in Firestore
2. Check Firebase Console → Functions → Logs
3. Verify that `onUserCreated` executed
4. Check that notifications collection received a welcome message

### Verify in Firebase Console

1. Go to Firebase Console → Functions
2. Click on any function to see details
3. View the "Logs" tab
4. Trigger functions from the app
5. Watch logs update in real-time

## 📸 Screenshots Guide

### Required Screenshots:

1. **Functions Deployed**
   - Firebase Console → Functions dashboard
   - Shows all 5 functions listed

2. **Callable Function Logs**
   - Firebase Console → Functions → Logs
   - Shows `sayHello` execution with parameters and response

3. **Event Trigger Logs**
   - Shows `onUserCreated` triggered by new document
   - Displays initialization and notification creation

4. **App UI - sayHello Response**
   - Demo screen showing function call
   - Response message displayed

5. **App UI - Book Recommendation**
   - Demo screen with form filled
   - Success message with book ID

## 💡 Real-World Use Cases

### Why Use Cloud Functions?

1. **Backend Logic Without Servers**
   - No server management required
   - Auto-scales with demand
   - Pay only for execution time

2. **Data Validation**
   - Validate user input before storing
   - Enforce business rules
   - Sanitize data

3. **Automated Workflows**
   - Send notifications on events
   - Generate thumbnails for uploaded images
   - Update related data automatically

4. **Security**
   - Run privileged code server-side
   - Protect API keys
   - Validate authentication

5. **Complex Processing**
   - Image manipulation
   - PDF generation
   - Email sending
   - Payment processing

### OpenShelf Use Cases

1. **User Management**
   - Auto-initialize profiles
   - Send welcome emails
   - Generate user recommendations

2. **Book Operations**
   - Validate ISBN numbers
   - Fetch book metadata from APIs
   - Generate book summaries

3. **Social Features**
   - Update user statistics
   - Calculate trending books
   - Send activity notifications

4. **Data Integrity**
   - Clean up orphaned data
   - Maintain referential integrity
   - Archive old records

## 🎓 What We Learned

### Technical Skills

- ✅ Setting up Firebase Cloud Functions
- ✅ Creating callable functions for direct invocation
- ✅ Implementing Firestore event triggers
- ✅ Handling authentication in functions
- ✅ Error handling and validation
- ✅ Integrating functions with Flutter
- ✅ Viewing and debugging function logs

### Best Practices

- Always validate input data
- Use TypeScript for better type safety (optional)
- Implement proper error handling
- Log important events for debugging
- Use security rules with functions
- Test locally with emulators

## 🔍 Reflection

### Why Serverless Reduces Backend Overhead

**Traditional Backend:**

- ❌ Must provision and maintain servers
- ❌ Handle scaling manually
- ❌ Monitor server health
- ❌ Manage security patches
- ❌ Pay for idle time

**Serverless with Cloud Functions:**

- ✅ No server management
- ✅ Auto-scales automatically
- ✅ Built-in monitoring
- ✅ Automatic updates
- ✅ Pay per execution
- ✅ Focus on business logic

### Function Choice: Callable vs Event-Triggered

**We implemented BOTH types:**

**Callable Functions** (`sayHello`, `addBookRecommendation`):

- Used for: User-initiated actions
- Benefits: Direct control, immediate response, pass parameters
- Examples: Search, process payment, fetch data

**Event-Triggered Functions** (`onUserCreated`, `onBookUpdated`, `onBookDeleted`):

- Used for: Automatic background tasks
- Benefits: No client code needed, runs reliably, maintains data integrity
- Examples: Send notifications, update analytics, cleanup

### Real-World Applications

1. **Content Moderation**
   - Auto-scan book reviews for inappropriate content
   - Flag suspicious activity

2. **Recommendation Engine**
   - Calculate personalized book suggestions
   - Update trending lists hourly

3. **Analytics Processing**
   - Aggregate reading statistics
   - Generate usage reports

4. **Integration with External APIs**
   - Fetch book details from Google Books API
   - Verify ISBN numbers
   - Send emails via SendGrid

5. **Scheduled Tasks**
   - Daily database cleanup
   - Weekly summary emails
   - Monthly usage reports

## 🔗 Resources

- [Cloud Functions Overview](https://firebase.google.com/docs/functions)
- [Callable Functions Guide](https://firebase.google.com/docs/functions/callable)
- [Firestore Triggers](https://firebase.google.com/docs/functions/firestore-events)
- [Flutter Cloud Functions Package](https://pub.dev/packages/cloud_functions)
- [Cloud Functions Samples](https://github.com/firebase/functions-samples)

## 📝 Next Steps

1. **Deploy Functions**: Run `firebase deploy --only functions`
2. **Test in App**: Open Cloud Functions Demo screen
3. **Check Logs**: View execution in Firebase Console
4. **Take Screenshots**: Document all required screenshots
5. **Create Video**: Record 1-2 minute demo
6. **Submit PR**: Include all documentation

## 🎬 Video Demo Checklist

Your video should show:

- [ ] Cloud Function files in VS Code
- [ ] Deploying functions (`firebase deploy --only functions`)
- [ ] Opening the demo screen in the app
- [ ] Calling sayHello function with your name
- [ ] Adding a book recommendation
- [ ] Firebase Console showing function logs
- [ ] Real-time log updates as functions execute
- [ ] Brief explanation of what each function does

---

**Created by**: TeamNova  
**Sprint**: Sprint-2  
**Feature**: Cloud Functions Implementation  
**Date**: February 2026
