import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

/// ============================================================================
/// FIRESTORE READ DEMO SCREEN
/// ============================================================================
///
/// This screen demonstrates all major Firestore read operations:
/// 1. Real-time streams with StreamBuilder (books collection)
/// 2. Single document read with FutureBuilder
/// 3. Filtered queries (available books only)
/// 4. Error handling and loading states
/// 5. Empty state handling
///
/// ============================================================================

class FirestoreReadDemo extends StatefulWidget {
  const FirestoreReadDemo({super.key});

  @override
  State<FirestoreReadDemo> createState() => _FirestoreReadDemoState();
}

class _FirestoreReadDemoState extends State<FirestoreReadDemo>
    with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  late TabController _tabController;
  bool _showAvailableOnly = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Read Operations'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.library_books), text: 'All Books'),
            Tab(icon: Icon(Icons.check_circle), text: 'Available'),
            Tab(icon: Icon(Icons.person), text: 'Single Doc'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllBooksTab(),
          _buildAvailableBooksTab(),
          _buildSingleDocumentTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSampleBook,
        icon: const Icon(Icons.add),
        label: const Text('Add Sample Book'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    );
  }

  // ============================================================================
  // TAB 1: ALL BOOKS (REAL-TIME STREAM)
  // ============================================================================

  Widget _buildAllBooksTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getBooksStream(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading books from Firestore...',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // No data state
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.library_books_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'No books found',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add your first book to get started!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _addSampleBook,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Sample Book'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Data available - display in ListView
        final books = snapshot.data!.docs;

        return Column(
          children: [
            // Stats header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.deepPurple.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('Total Books', '${books.length}', Icons.book),
                  _buildStatCard(
                    'Available',
                    '${books.where((doc) => doc['available'] == true).length}',
                    Icons.check_circle,
                  ),
                  _buildStatCard(
                    'Unavailable',
                    '${books.where((doc) => doc['available'] != true).length}',
                    Icons.block,
                  ),
                ],
              ),
            ),

            // Books list
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final book = books[index];
                  final data = book.data() as Map<String, dynamic>;

                  return _buildBookCard(
                    bookId: book.id,
                    title: data['title'] ?? 'Untitled',
                    author: data['author'] ?? 'Unknown Author',
                    available: data['available'] ?? false,
                    isbn: data['isbn'] ?? '',
                    description: data['description'] ?? '',
                    genre: List<String>.from(data['genre'] ?? []),
                    createdAt: data['createdAt'] as Timestamp?,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================================
  // TAB 2: AVAILABLE BOOKS ONLY (FILTERED QUERY)
  // ============================================================================

  Widget _buildAvailableBooksTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getAvailableBooksStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No available books',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'All books are currently unavailable',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final books = snapshot.data!.docs;

        return Column(
          children: [
            // Filter info banner
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.filter_alt, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Showing ${books.length} available books',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Available books list
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final book = books[index];
                  final data = book.data() as Map<String, dynamic>;

                  return _buildBookCard(
                    bookId: book.id,
                    title: data['title'] ?? 'Untitled',
                    author: data['author'] ?? 'Unknown Author',
                    available: data['available'] ?? false,
                    isbn: data['isbn'] ?? '',
                    description: data['description'] ?? '',
                    genre: List<String>.from(data['genre'] ?? []),
                    createdAt: data['createdAt'] as Timestamp?,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================================
  // TAB 3: SINGLE DOCUMENT READ (FUTUREBUILDER)
  // ============================================================================

  Widget _buildSingleDocumentTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getBooksStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Add books first to view single document details'),
          );
        }

        final firstBook = snapshot.data!.docs.first;

        return FutureBuilder<DocumentSnapshot>(
          future: _firestoreService.getBookById(firstBook.id),
          builder: (context, bookSnapshot) {
            if (bookSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading single document...'),
                  ],
                ),
              );
            }

            if (bookSnapshot.hasError) {
              return Center(child: Text('Error: ${bookSnapshot.error}'));
            }

            if (!bookSnapshot.hasData || !bookSnapshot.data!.exists) {
              return const Center(child: Text('Document not found'));
            }

            final data = bookSnapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 32,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Single Document Read (FutureBuilder)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Document details
                  _buildDetailRow('Document ID', bookSnapshot.data!.id),
                  _buildDetailRow('Title', data['title'] ?? 'N/A'),
                  _buildDetailRow('Author', data['author'] ?? 'N/A'),
                  _buildDetailRow('ISBN', data['isbn'] ?? 'N/A'),
                  _buildDetailRow(
                    'Description',
                    data['description'] ?? 'No description',
                  ),
                  _buildDetailRow(
                    'Genre',
                    (data['genre'] as List?)?.join(', ') ?? 'None',
                  ),
                  _buildDetailRow(
                    'Available',
                    data['available'] == true ? 'Yes ✓' : 'No ✗',
                  ),
                  _buildDetailRow(
                    'Created At',
                    _formatTimestamp(data['createdAt'] as Timestamp?),
                  ),
                  _buildDetailRow(
                    'Updated At',
                    _formatTimestamp(data['updatedAt'] as Timestamp?),
                  ),

                  const SizedBox(height: 24),

                  // Raw data
                  const Text(
                    'Raw Document Data:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      data.toString(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================================
  // HELPER WIDGETS
  // ============================================================================

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.deepPurple),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildBookCard({
    required String bookId,
    required String title,
    required String author,
    required bool available,
    String? isbn,
    String? description,
    List<String>? genre,
    Timestamp? createdAt,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: available
              ? Colors.green.shade100
              : Colors.red.shade100,
          child: Icon(
            available ? Icons.check_circle : Icons.block,
            color: available ? Colors.green : Colors.red,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('by $author'),
            if (genre != null && genre.isNotEmpty)
              Text(
                genre.join(', '),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            if (createdAt != null)
              Text(
                'Added: ${_formatTimestamp(createdAt)}',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Toggle Availability'),
              onTap: () => _toggleAvailability(bookId, available),
            ),
            PopupMenuItem(
              child: const Text('Delete'),
              onTap: () => _deleteBook(bookId),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // ============================================================================
  // ACTIONS
  // ============================================================================

  Future<void> _addSampleBook() async {
    try {
      final titles = [
        'The Alchemist',
        '1984',
        'To Kill a Mockingbird',
        'Pride and Prejudice',
        'The Great Gatsby',
      ];
      final authors = [
        'Paulo Coelho',
        'George Orwell',
        'Harper Lee',
        'Jane Austen',
        'F. Scott Fitzgerald',
      ];
      final genres = [
        ['Fiction', 'Philosophy'],
        ['Dystopian', 'Science Fiction'],
        ['Classic', 'Drama'],
        ['Romance', 'Classic'],
        ['Classic', 'Tragedy'],
      ];

      final random = DateTime.now().millisecondsSinceEpoch % titles.length;

      await _firestoreService.addBook(
        titles[random],
        authors[random],
        isbn: '978-${DateTime.now().millisecondsSinceEpoch % 10000000000}',
        description: 'A great book that you should definitely read!',
        genre: genres[random],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added "${titles[random]}" to Firestore'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding book: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleAvailability(String bookId, bool currentStatus) async {
    try {
      await _firestoreService.updateBookAvailability(bookId, !currentStatus);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Book ${!currentStatus ? 'marked as available' : 'marked as unavailable'}',
            ),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating book: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteBook(String bookId) async {
    try {
      await _firestoreService.deleteBook(bookId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book deleted from Firestore'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting book: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
