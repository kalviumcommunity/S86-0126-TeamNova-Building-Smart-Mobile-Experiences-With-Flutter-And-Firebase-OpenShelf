import 'package:cloud_firestore/cloud_firestore.dart';

/// ============================================================================
/// FIRESTORE SERVICE - COMPREHENSIVE READ OPERATIONS
/// ============================================================================
///
/// This service demonstrates all major Firestore read patterns:
/// 1. Single document read (one-time)
/// 2. Collection read (one-time)
/// 3. Real-time streams (live updates)
/// 4. Filtered queries
/// 5. Ordered results
///
/// ============================================================================

class FirestoreService {
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get books => _firestore.collection('books');
  CollectionReference get users => _firestore.collection('users');
  CollectionReference get categories => _firestore.collection('categories');

  // ============================================================================
  // BOOKS COLLECTION - READ OPERATIONS
  // ============================================================================

  /// Get all books as a real-time stream
  /// This automatically updates when Firestore data changes
  Stream<QuerySnapshot> getBooksStream() {
    return books.orderBy('createdAt', descending: true).snapshots();
  }

  /// Get a single book by ID (one-time read)
  Future<DocumentSnapshot> getBookById(String bookId) async {
    try {
      return await books.doc(bookId).get();
    } catch (e) {
      throw Exception('Error fetching book: $e');
    }
  }

  /// Get all books (one-time read)
  Future<QuerySnapshot> getAllBooks() async {
    try {
      return await books.orderBy('title').get();
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  /// Get available books only (filtered query)
  Stream<QuerySnapshot> getAvailableBooksStream() {
    return books
        .where('available', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Get books by author (filtered query)
  Stream<QuerySnapshot> getBooksByAuthor(String author) {
    return books.where('author', isEqualTo: author).snapshots();
  }

  /// Search books by title (partial match)
  Future<QuerySnapshot> searchBooksByTitle(String searchTerm) async {
    try {
      return await books
          .where('title', isGreaterThanOrEqualTo: searchTerm)
          .where('title', isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .get();
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }

  // ============================================================================
  // USERS COLLECTION - READ OPERATIONS
  // ============================================================================

  /// Get user profile by ID
  Future<DocumentSnapshot> getUserById(String userId) async {
    try {
      return await users.doc(userId).get();
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  /// Get user profile as a stream (real-time updates)
  Stream<DocumentSnapshot> getUserStream(String userId) {
    return users.doc(userId).snapshots();
  }

  /// Get all users (one-time read)
  Future<QuerySnapshot> getAllUsers() async {
    try {
      return await users.orderBy('displayName').get();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // ============================================================================
  // CATEGORIES COLLECTION - READ OPERATIONS
  // ============================================================================

  /// Get all categories as a stream
  Stream<QuerySnapshot> getCategoriesStream() {
    return categories.orderBy('order').snapshots();
  }

  /// Get active categories only
  Stream<QuerySnapshot> getActiveCategoriesStream() {
    return categories
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots();
  }

  // ============================================================================
  // WRITE OPERATIONS (from previous implementation)
  // ============================================================================

  /// Add a new book to Firestore
  Future<DocumentReference> addBook(
    String title,
    String author, {
    String? isbn,
    String? description,
    String? coverImageUrl,
    List<String>? genre,
  }) async {
    try {
      return await books.add({
        'title': title,
        'author': author,
        'isbn': isbn ?? '',
        'description': description ?? '',
        'coverImageUrl': coverImageUrl ?? '',
        'genre': genre ?? [],
        'available': true,
        'averageRating': 0.0,
        'totalRatings': 0,
        'totalReviews': 0,
        'copiesAvailable': 1,
        'totalCopies': 1,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error adding book: $e');
    }
  }

  /// Update book availability
  Future<void> updateBookAvailability(String bookId, bool available) async {
    try {
      await books.doc(bookId).update({
        'available': available,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error updating book: $e');
    }
  }

  /// Delete a book by ID
  Future<void> deleteBook(String docId) async {
    try {
      await books.doc(docId).delete();
    } catch (e) {
      throw Exception('Error deleting book: $e');
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get total count of books in a collection
  Future<int> getBooksCount() async {
    try {
      final snapshot = await books.get();
      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Error counting books: $e');
    }
  }

  /// Check if a book exists
  Future<bool> bookExists(String bookId) async {
    try {
      final doc = await books.doc(bookId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
