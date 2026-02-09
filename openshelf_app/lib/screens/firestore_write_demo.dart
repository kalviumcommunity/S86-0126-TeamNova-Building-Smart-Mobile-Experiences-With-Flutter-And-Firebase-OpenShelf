import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

/// ============================================================================
/// FIRESTORE WRITE OPERATIONS DEMO SCREEN
/// ============================================================================
///
/// This screen demonstrates all Firestore write operations:
/// 1. ADD - Create new documents with auto-generated IDs
/// 2. SET - Write to specific document IDs (with merge options)
/// 3. UPDATE - Modify specific fields in existing documents
/// 4. Validation - Ensure data integrity before writing
/// 5. Error handling - Graceful failure management
///
/// ============================================================================

class FirestoreWriteDemo extends StatefulWidget {
  const FirestoreWriteDemo({super.key});

  @override
  State<FirestoreWriteDemo> createState() => _FirestoreWriteDemoState();
}

class _FirestoreWriteDemoState extends State<FirestoreWriteDemo>
    with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  late TabController _tabController;

  // Form controllers for adding books
  final _addTitleController = TextEditingController();
  final _addAuthorController = TextEditingController();
  final _addIsbnController = TextEditingController();
  final _addDescriptionController = TextEditingController();
  final _addGenreController = TextEditingController();

  // Form controllers for updating books
  final _updateTitleController = TextEditingController();
  final _updateAuthorController = TextEditingController();
  final _updateDescriptionController = TextEditingController();

  // Form keys for validation
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  String? _selectedBookId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _addTitleController.dispose();
    _addAuthorController.dispose();
    _addIsbnController.dispose();
    _addDescriptionController.dispose();
    _addGenreController.dispose();
    _updateTitleController.dispose();
    _updateAuthorController.dispose();
    _updateDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Write Operations'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.add_circle), text: 'Add'),
            Tab(icon: Icon(Icons.edit), text: 'Update'),
            Tab(icon: Icon(Icons.view_list), text: 'View All'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildAddTab(), _buildUpdateTab(), _buildViewAllTab()],
      ),
    );
  }

  // ============================================================================
  // TAB 1: ADD OPERATION (CREATE NEW DOCUMENTS)
  // ============================================================================

  Widget _buildAddTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _addFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: const Column(
                children: [
                  Icon(Icons.add_circle, size: 48, color: Colors.green),
                  SizedBox(height: 8),
                  Text(
                    'ADD Operation',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Creates new document with auto-generated ID',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Code Example
            _buildCodeExample('ADD Example', '''await FirebaseFirestore.instance
  .collection('books')
  .add({
    'title': 'Book Title',
    'author': 'Author Name',
    'available': true,
    'createdAt': Timestamp.now(),
  });'''),

            const SizedBox(height: 24),

            // Form Fields
            TextFormField(
              controller: _addTitleController,
              decoration: const InputDecoration(
                labelText: 'Book Title *',
                hintText: 'Enter book title',
                prefixIcon: Icon(Icons.book),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                if (value.trim().length < 3) {
                  return 'Title must be at least 3 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _addAuthorController,
              decoration: const InputDecoration(
                labelText: 'Author *',
                hintText: 'Enter author name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Author is required';
                }
                if (value.trim().length < 2) {
                  return 'Author name must be at least 2 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _addIsbnController,
              decoration: const InputDecoration(
                labelText: 'ISBN',
                hintText: 'Enter ISBN (optional)',
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _addDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter book description (optional)',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _addGenreController,
              decoration: const InputDecoration(
                labelText: 'Genre',
                hintText: 'e.g., Fiction, Science, History (comma-separated)',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Add Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _addBook,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.add),
              label: Text(_isLoading ? 'Adding...' : 'Add Book to Firestore'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 16),

            // Clear Button
            OutlinedButton.icon(
              onPressed: _clearAddForm,
              icon: const Icon(Icons.clear),
              label: const Text('Clear Form'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // TAB 2: UPDATE OPERATION (MODIFY EXISTING DOCUMENTS)
  // ============================================================================

  Widget _buildUpdateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: const Column(
              children: [
                Icon(Icons.edit, size: 48, color: Colors.blue),
                SizedBox(height: 8),
                Text(
                  'UPDATE Operation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Modifies specific fields in existing document',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Code Example
          _buildCodeExample(
            'UPDATE Example',
            '''await FirebaseFirestore.instance
  .collection('books')
  .doc(bookId)
  .update({
    'title': 'Updated Title',
    'updatedAt': Timestamp.now(),
  });''',
          ),

          const SizedBox(height: 24),

          // Select Book
          const Text(
            'Step 1: Select a Book to Update',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          StreamBuilder<QuerySnapshot>(
            stream: _firestoreService.getBooksStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        const Text('No books available to update'),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => _tabController.animateTo(0),
                          child: const Text('Add a book first'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final books = snapshot.data!.docs;

              return Card(
                child: Column(
                  children: books.map((book) {
                    final data = book.data() as Map<String, dynamic>;
                    final isSelected = _selectedBookId == book.id;

                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: Colors.blue.withOpacity(0.1),
                      leading: CircleAvatar(
                        backgroundColor: isSelected ? Colors.blue : Colors.grey,
                        child: Icon(
                          isSelected ? Icons.check : Icons.book,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        data['title'] ?? 'Untitled',
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text('by ${data['author'] ?? 'Unknown'}'),
                      trailing: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected ? Colors.blue : Colors.grey,
                      ),
                      onTap: () => _selectBookForUpdate(book.id, data),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Update Form
          if (_selectedBookId != null) ...[
            const Text(
              'Step 2: Modify Fields',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Form(
              key: _updateFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _updateTitleController,
                    decoration: const InputDecoration(
                      labelText: 'New Title',
                      hintText: 'Enter new title',
                      prefixIcon: Icon(Icons.book),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title cannot be empty';
                      }
                      if (value.trim().length < 3) {
                        return 'Title must be at least 3 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _updateAuthorController,
                    decoration: const InputDecoration(
                      labelText: 'New Author',
                      hintText: 'Enter new author',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Author cannot be empty';
                      }
                      if (value.trim().length < 2) {
                        return 'Author must be at least 2 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _updateDescriptionController,
                    decoration: const InputDecoration(
                      labelText: 'New Description',
                      hintText: 'Enter new description (optional)',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _updateBook,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.update),
                    label: Text(
                      _isLoading ? 'Updating...' : 'Update Book in Firestore',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: _clearUpdateForm,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Selection'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.touch_app, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Select a book from the list above to update',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================================
  // TAB 3: VIEW ALL (WITH DELETE OPTION)
  // ============================================================================

  Widget _buildViewAllTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getBooksStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.library_books_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text('No books in Firestore'),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _tabController.animateTo(0),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Your First Book'),
                ),
              ],
            ),
          );
        }

        final books = snapshot.data!.docs;

        return Column(
          children: [
            // Stats Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.deepOrange.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('Total', '${books.length}', Icons.book),
                  _buildStatCard(
                    'Available',
                    '${books.where((doc) => doc['available'] == true).length}',
                    Icons.check_circle,
                  ),
                ],
              ),
            ),

            // Books List
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final book = books[index];
                  final data = book.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: data['available'] == true
                            ? Colors.green
                            : Colors.red,
                        child: Icon(
                          data['available'] == true
                              ? Icons.check_circle
                              : Icons.block,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        data['title'] ?? 'Untitled',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('by ${data['author'] ?? 'Unknown'}'),
                          if (data['description'] != null &&
                              data['description'].toString().isNotEmpty)
                            Text(
                              data['description'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                            onTap: () {
                              Future.delayed(Duration.zero, () {
                                _tabController.animateTo(1);
                                _selectBookForUpdate(book.id, data);
                              });
                            },
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  data['available'] == true
                                      ? Icons.block
                                      : Icons.check_circle,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  data['available'] == true
                                      ? 'Mark Unavailable'
                                      : 'Mark Available',
                                ),
                              ],
                            ),
                            onTap: () => _toggleAvailability(
                              book.id,
                              data['available'] ?? false,
                            ),
                          ),
                          PopupMenuItem(
                            child: const Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            onTap: () => _deleteBook(book.id),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
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
  // HELPER WIDGETS
  // ============================================================================

  Widget _buildCodeExample(String title, String code) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            code,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.deepOrange),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // ============================================================================
  // WRITE OPERATIONS
  // ============================================================================

  /// ADD Operation - Creates new document with auto-generated ID
  Future<void> _addBook() async {
    if (!_addFormKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final title = _addTitleController.text.trim();
      final author = _addAuthorController.text.trim();
      final isbn = _addIsbnController.text.trim();
      final description = _addDescriptionController.text.trim();
      final genreInput = _addGenreController.text.trim();

      // Parse genres (comma-separated)
      final genres = genreInput.isEmpty
          ? <String>[]
          : genreInput
                .split(',')
                .map((g) => g.trim())
                .where((g) => g.isNotEmpty)
                .toList();

      // Call service method
      await _firestoreService.addBook(
        title,
        author,
        isbn: isbn.isEmpty ? null : isbn,
        description: description.isEmpty ? null : description,
        genre: genres.isEmpty ? null : genres,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Book "$title" added successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Clear form
        _clearAddForm();

        // Switch to view tab
        _tabController.animateTo(2);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding book: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// UPDATE Operation - Modifies specific fields in existing document
  Future<void> _updateBook() async {
    if (_selectedBookId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a book to update'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_updateFormKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final title = _updateTitleController.text.trim();
      final author = _updateAuthorController.text.trim();
      final description = _updateDescriptionController.text.trim();

      // Build update map (only non-empty fields)
      final Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (title.isNotEmpty) updateData['title'] = title;
      if (author.isNotEmpty) updateData['author'] = author;
      if (description.isNotEmpty) updateData['description'] = description;

      // Call Firestore update
      await FirebaseFirestore.instance
          .collection('books')
          .doc(_selectedBookId)
          .update(updateData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Book updated successfully!'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Clear form
        _clearUpdateForm();

        // Switch to view tab
        _tabController.animateTo(2);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating book: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Toggle book availability (UPDATE example)
  Future<void> _toggleAvailability(String bookId, bool currentStatus) async {
    try {
      await _firestoreService.updateBookAvailability(bookId, !currentStatus);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✓ Book ${!currentStatus ? 'marked as available' : 'marked as unavailable'}',
            ),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating availability: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Delete book (DELETE operation)
  Future<void> _deleteBook(String bookId) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _firestoreService.deleteBook(bookId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Book deleted successfully'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
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

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  void _selectBookForUpdate(String bookId, Map<String, dynamic> data) {
    setState(() {
      _selectedBookId = bookId;
      _updateTitleController.text = data['title'] ?? '';
      _updateAuthorController.text = data['author'] ?? '';
      _updateDescriptionController.text = data['description'] ?? '';
    });
  }

  void _clearAddForm() {
    _addFormKey.currentState?.reset();
    _addTitleController.clear();
    _addAuthorController.clear();
    _addIsbnController.clear();
    _addDescriptionController.clear();
    _addGenreController.clear();
  }

  void _clearUpdateForm() {
    _updateFormKey.currentState?.reset();
    _updateTitleController.clear();
    _updateAuthorController.clear();
    _updateDescriptionController.clear();
    setState(() => _selectedBookId = null);
  }
}
