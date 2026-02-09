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
  // ADVANCED QUERY OPERATIONS - FILTERS, SORTING, PAGINATION
  // ============================================================================

  // ------------------ EQUALITY FILTERS ------------------

  /// Get books where field equals a specific value
  /// Example: Get books in stock
  Stream<QuerySnapshot> getBooksWhereEqual(String field, dynamic value) {
    return books.where(field, isEqualTo: value).snapshots();
  }

  /// Get books in stock (available)
  Stream<QuerySnapshot> getBooksInStock() {
    return books.where('available', isEqualTo: true).snapshots();
  }

  /// Get books by specific genre (array contains)
  Stream<QuerySnapshot> getBooksByGenre(String genre) {
    return books.where('genre', arrayContains: genre).snapshots();
  }

  // ------------------ COMPARISON FILTERS ------------------

  /// Get books with price greater than specified amount
  Stream<QuerySnapshot> getBooksAbovePrice(double price) {
    return books.where('price', isGreaterThan: price).snapshots();
  }

  /// Get books with price less than specified amount
  Stream<QuerySnapshot> getBooksBelowPrice(double price) {
    return books.where('price', isLessThan: price).snapshots();
  }

  /// Get books with rating greater than or equal to threshold
  Stream<QuerySnapshot> getBooksByMinRating(double minRating) {
    return books
        .where('averageRating', isGreaterThanOrEqualTo: minRating)
        .snapshots();
  }

  /// Get highly rated books (rating >= 4.0)
  Stream<QuerySnapshot> getHighlyRatedBooks() {
    return books
        .where('averageRating', isGreaterThanOrEqualTo: 4.0)
        .orderBy('averageRating', descending: true)
        .snapshots();
  }

  // ------------------ SORTING (ORDER BY) ------------------

  /// Get all books sorted by creation date (newest first)
  Stream<QuerySnapshot> getBooksSortedByNewest() {
    return books.orderBy('createdAt', descending: true).snapshots();
  }

  /// Get all books sorted by title (alphabetically)
  Stream<QuerySnapshot> getBooksSortedByTitle() {
    return books.orderBy('title').snapshots();
  }

  /// Get all books sorted by rating (highest first)
  Stream<QuerySnapshot> getBooksSortedByRating() {
    return books.orderBy('averageRating', descending: true).snapshots();
  }

  /// Get all books sorted by price (lowest first)
  Stream<QuerySnapshot> getBooksSortedByPriceLowToHigh() {
    return books.orderBy('price').snapshots();
  }

  /// Get all books sorted by price (highest first)
  Stream<QuerySnapshot> getBooksSortedByPriceHighToLow() {
    return books.orderBy('price', descending: true).snapshots();
  }

  // ------------------ COMBINED FILTERS + SORTING ------------------

  /// Get available books sorted by rating
  Stream<QuerySnapshot> getAvailableBooksByRating() {
    return books
        .where('available', isEqualTo: true)
        .orderBy('averageRating', descending: true)
        .snapshots();
  }

  /// Get books in a price range
  Stream<QuerySnapshot> getBooksInPriceRange(double minPrice, double maxPrice) {
    return books
        .where('price', isGreaterThanOrEqualTo: minPrice)
        .where('price', isLessThanOrEqualTo: maxPrice)
        .orderBy('price')
        .snapshots();
  }

  /// Get available books in a specific genre sorted by rating
  Stream<QuerySnapshot> getAvailableBooksByGenreAndRating(String genre) {
    return books
        .where('available', isEqualTo: true)
        .where('genre', arrayContains: genre)
        .orderBy('averageRating', descending: true)
        .snapshots();
  }

  // ------------------ PAGINATION & LIMITING ------------------

  /// Get limited number of books (for initial load)
  Stream<QuerySnapshot> getTopBooks(int limit) {
    return books
        .orderBy('averageRating', descending: true)
        .limit(limit)
        .snapshots();
  }

  /// Get recent books with limit
  Stream<QuerySnapshot> getRecentBooks(int limit) {
    return books
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  /// Get top N books in a genre
  Stream<QuerySnapshot> getTopBooksInGenre(String genre, int limit) {
    return books
        .where('genre', arrayContains: genre)
        .orderBy('averageRating', descending: true)
        .limit(limit)
        .snapshots();
  }

  // ------------------ MULTIPLE CONDITIONS ------------------

  /// Get available, highly-rated books (compound query)
  Stream<QuerySnapshot> getPremiumBooks() {
    return books
        .where('available', isEqualTo: true)
        .where('averageRating', isGreaterThanOrEqualTo: 4.5)
        .orderBy('averageRating', descending: true)
        .snapshots();
  }

  /// Get books with minimum copies available
  Stream<QuerySnapshot> getBooksWithStock(int minCopies) {
    return books
        .where('copiesAvailable', isGreaterThanOrEqualTo: minCopies)
        .orderBy('copiesAvailable', descending: true)
        .snapshots();
  }

  // ------------------ REAL-TIME FILTERED SEARCHES ------------------

  /// Get books matching multiple criteria (status + category + rating)
  Stream<QuerySnapshot> getFilteredBooks({
    bool? available,
    String? genre,
    double? minRating,
    int? limit,
  }) {
    Query query = books;

    if (available != null) {
      query = query.where('available', isEqualTo: available);
    }

    if (genre != null) {
      query = query.where('genre', arrayContains: genre);
    }

    if (minRating != null) {
      query = query.where('averageRating', isGreaterThanOrEqualTo: minRating);
      query = query.orderBy('averageRating', descending: true);
    } else {
      query = query.orderBy('createdAt', descending: true);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots();
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
