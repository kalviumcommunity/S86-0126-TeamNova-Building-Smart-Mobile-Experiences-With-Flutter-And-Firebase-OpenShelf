import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

/// ============================================================================
/// FIRESTORE QUERIES & FILTERING DEMO
/// ============================================================================
///
/// This screen demonstrates comprehensive Firestore query capabilities:
/// - WHERE filters (equality, comparison, array)
/// - ORDER BY sorting (ascending, descending)
/// - LIMIT pagination
/// - Combined queries
/// - Real-time UI updates with StreamBuilder
///
/// ============================================================================

class FirestoreQueriesDemo extends StatefulWidget {
  const FirestoreQueriesDemo({super.key});

  @override
  State<FirestoreQueriesDemo> createState() => _FirestoreQueriesDemoState();
}

class _FirestoreQueriesDemoState extends State<FirestoreQueriesDemo> {
  final FirestoreService _firestoreService = FirestoreService();

  // Query filter options
  String _selectedQueryType = 'all';
  String _selectedSortOrder = 'newest';
  String? _selectedGenre;
  double _minRating = 0.0;
  double _minPrice = 0.0;
  double _maxPrice = 1000.0;
  int _resultLimit = 20;

  // Available genres for filtering
  final List<String> _genres = [
    'Fiction',
    'Non-Fiction',
    'Science',
    'History',
    'Biography',
    'Technology',
    'Fantasy',
    'Mystery',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Queries & Filters'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter controls
          _buildFilterPanel(),

          const Divider(height: 1),

          // Results display
          Expanded(child: _buildResultsView()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSampleBook,
        icon: const Icon(Icons.add),
        label: const Text('Add Sample Book'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  // ============================================================================
  // FILTER PANEL
  // ============================================================================

  Widget _buildFilterPanel() {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔍 Query Filters',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Query Type Selector
          _buildQueryTypeSelector(),
          const SizedBox(height: 12),

          // Sort Order Selector
          _buildSortOrderSelector(),
          const SizedBox(height: 12),

          // Additional filters based on query type
          if (_selectedQueryType == 'genre') _buildGenreSelector(),
          if (_selectedQueryType == 'rating') _buildRatingFilter(),
          if (_selectedQueryType == 'priceRange') _buildPriceRangeFilter(),
          if (_selectedQueryType == 'limited') _buildLimitSelector(),

          const SizedBox(height: 12),

          // Active query info
          _buildActiveQueryInfo(),
        ],
      ),
    );
  }

  Widget _buildQueryTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Query Type:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFilterChip('All Books', 'all'),
            _buildFilterChip('In Stock', 'inStock'),
            _buildFilterChip('By Genre', 'genre'),
            _buildFilterChip('High Rated (≥4.0)', 'highRated'),
            _buildFilterChip('By Rating', 'rating'),
            _buildFilterChip('Price Range', 'priceRange'),
            _buildFilterChip('Limited Results', 'limited'),
            _buildFilterChip('Premium (Available + High Rating)', 'premium'),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedQueryType == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedQueryType = value;
        });
      },
      selectedColor: Colors.deepPurple.withOpacity(0.3),
      checkmarkColor: Colors.deepPurple,
    );
  }

  Widget _buildSortOrderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sort Order:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Newest First'),
              selected: _selectedSortOrder == 'newest',
              onSelected: (selected) {
                setState(() => _selectedSortOrder = 'newest');
              },
            ),
            ChoiceChip(
              label: const Text('Title A-Z'),
              selected: _selectedSortOrder == 'title',
              onSelected: (selected) {
                setState(() => _selectedSortOrder = 'title');
              },
            ),
            ChoiceChip(
              label: const Text('Rating (High)'),
              selected: _selectedSortOrder == 'rating',
              onSelected: (selected) {
                setState(() => _selectedSortOrder = 'rating');
              },
            ),
            ChoiceChip(
              label: const Text('Price (Low)'),
              selected: _selectedSortOrder == 'priceLow',
              onSelected: (selected) {
                setState(() => _selectedSortOrder = 'priceLow');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenreSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Genre:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: _selectedGenre,
          hint: const Text('Choose a genre'),
          isExpanded: true,
          items: _genres.map((genre) {
            return DropdownMenuItem(value: genre, child: Text(genre));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedGenre = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Rating: ${_minRating.toStringAsFixed(1)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Slider(
          value: _minRating,
          min: 0,
          max: 5,
          divisions: 10,
          label: _minRating.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              _minRating = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range: \$${_minPrice.toStringAsFixed(0)} - \$${_maxPrice.toStringAsFixed(0)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Min:', style: TextStyle(fontSize: 12)),
                  Slider(
                    value: _minPrice,
                    min: 0,
                    max: 500,
                    divisions: 10,
                    label: '\$${_minPrice.toStringAsFixed(0)}',
                    onChanged: (value) {
                      setState(() {
                        _minPrice = value;
                        if (_minPrice > _maxPrice) {
                          _maxPrice = _minPrice;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Max:', style: TextStyle(fontSize: 12)),
                  Slider(
                    value: _maxPrice,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    label: '\$${_maxPrice.toStringAsFixed(0)}',
                    onChanged: (value) {
                      setState(() {
                        _maxPrice = value;
                        if (_maxPrice < _minPrice) {
                          _minPrice = _maxPrice;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLimitSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Result Limit: $_resultLimit items',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Slider(
          value: _resultLimit.toDouble(),
          min: 5,
          max: 50,
          divisions: 9,
          label: '$_resultLimit',
          onChanged: (value) {
            setState(() {
              _resultLimit = value.toInt();
            });
          },
        ),
      ],
    );
  }

  Widget _buildActiveQueryInfo() {
    String queryDescription = _getQueryDescription();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              queryDescription,
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  String _getQueryDescription() {
    String base = '';
    switch (_selectedQueryType) {
      case 'all':
        base = '.collection("books")';
        break;
      case 'inStock':
        base = '.where("available", isEqualTo: true)';
        break;
      case 'genre':
        base =
            '.where("genre", arrayContains: "${_selectedGenre ?? 'Fiction'}")';
        break;
      case 'highRated':
        base = '.where("averageRating", isGreaterThanOrEqualTo: 4.0)';
        break;
      case 'rating':
        base = '.where("averageRating", isGreaterThanOrEqualTo: $_minRating)';
        break;
      case 'priceRange':
        base =
            '.where("price", isGreaterThanOrEqualTo: $_minPrice).where("price", isLessThanOrEqualTo: $_maxPrice)';
        break;
      case 'limited':
        base = '.collection("books").limit($_resultLimit)';
        break;
      case 'premium':
        base =
            '.where("available", isEqualTo: true).where("averageRating", isGreaterThanOrEqualTo: 4.5)';
        break;
    }

    String sortStr = '';
    switch (_selectedSortOrder) {
      case 'newest':
        sortStr = '.orderBy("createdAt", descending: true)';
        break;
      case 'title':
        sortStr = '.orderBy("title")';
        break;
      case 'rating':
        sortStr = '.orderBy("averageRating", descending: true)';
        break;
      case 'priceLow':
        sortStr = '.orderBy("price")';
        break;
    }

    return 'Query: $base$sortStr.snapshots()';
  }

  // ============================================================================
  // RESULTS VIEW WITH STREAMBUILDER
  // ============================================================================

  Widget _buildResultsView() {
    // Get the appropriate stream based on selected filters
    Stream<QuerySnapshot> stream = _getQueryStream();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading books from Firestore...'),
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
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => setState(() {}),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.book_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No books match your query',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try adjusting your filters or add sample books',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _addSampleBook,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Sample Book'),
                ),
              ],
            ),
          );
        }

        // Data state - display books
        final books = snapshot.data!.docs;

        return Column(
          children: [
            // Results count header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.green.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 12),
                  Text(
                    '${books.length} book${books.length == 1 ? '' : 's'} found',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // Books list
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final book = books[index];
                  final data = book.data() as Map<String, dynamic>;

                  return _buildBookCard(book.id, data);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBookCard(String bookId, Map<String, dynamic> data) {
    final title = data['title'] ?? 'Untitled';
    final author = data['author'] ?? 'Unknown Author';
    final available = data['available'] ?? false;
    final rating = (data['averageRating'] ?? 0.0).toDouble();
    final price = (data['price'] ?? 0.0).toDouble();
    final genre = (data['genre'] as List<dynamic>?)?.join(', ') ?? 'No genre';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: available ? Colors.green : Colors.red,
          child: Icon(
            available ? Icons.check : Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('by $author'),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(rating.toStringAsFixed(1)),
                const SizedBox(width: 16),
                const Icon(Icons.attach_money, size: 16, color: Colors.green),
                Text(price.toStringAsFixed(2)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              genre,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              available ? Icons.check_circle : Icons.block,
              color: available ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 4),
            Text(
              available ? 'In Stock' : 'Out',
              style: TextStyle(
                fontSize: 10,
                color: available ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        onTap: () => _showBookDetails(bookId, data),
      ),
    );
  }

  // ============================================================================
  // QUERY STREAM SELECTOR
  // ============================================================================

  Stream<QuerySnapshot> _getQueryStream() {
    Stream<QuerySnapshot> stream;

    // First, apply the filter
    switch (_selectedQueryType) {
      case 'inStock':
        stream = _firestoreService.getBooksInStock();
        break;
      case 'genre':
        stream = _firestoreService.getBooksByGenre(_selectedGenre ?? 'Fiction');
        break;
      case 'highRated':
        stream = _firestoreService.getHighlyRatedBooks();
        break;
      case 'rating':
        stream = _firestoreService.getBooksByMinRating(_minRating);
        break;
      case 'priceRange':
        stream = _firestoreService.getBooksInPriceRange(_minPrice, _maxPrice);
        break;
      case 'limited':
        stream = _firestoreService.getTopBooks(_resultLimit);
        break;
      case 'premium':
        stream = _firestoreService.getPremiumBooks();
        break;
      default: // 'all'
        // Apply sorting for 'all' case
        switch (_selectedSortOrder) {
          case 'title':
            stream = _firestoreService.getBooksSortedByTitle();
            break;
          case 'rating':
            stream = _firestoreService.getBooksSortedByRating();
            break;
          case 'priceLow':
            stream = _firestoreService.getBooksSortedByPriceLowToHigh();
            break;
          default: // 'newest'
            stream = _firestoreService.getBooksSortedByNewest();
        }
    }

    return stream;
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  void _showBookDetails(String bookId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(data['title'] ?? 'Book Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Author: ${data['author']}'),
            Text('Rating: ${data['averageRating']}'),
            Text('Price: \$${data['price']}'),
            Text('Available: ${data['available']}'),
            Text('Genre: ${(data['genre'] as List?)?.join(', ') ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text('ID: $bookId', style: const TextStyle(fontSize: 10)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addSampleBook() async {
    final random = DateTime.now().millisecondsSinceEpoch % 1000;
    final sampleGenres = ['Fiction', 'Science', 'History'];
    final sampleAuthors = [
      'John Doe',
      'Jane Smith',
      'Robert Brown',
      'Emily White',
    ];

    try {
      await _firestoreService.addBook(
        'Sample Book $random',
        sampleAuthors[random % sampleAuthors.length],
        isbn: 'ISBN-$random',
        description: 'This is a sample book for testing queries',
        genre: [sampleGenres[random % sampleGenres.length]],
      );

      // Also update it with price and rating
      final booksSnapshot = await FirebaseFirestore.instance
          .collection('books')
          .where('title', isEqualTo: 'Sample Book $random')
          .get();

      if (booksSnapshot.docs.isNotEmpty) {
        final docId = booksSnapshot.docs.first.id;
        await FirebaseFirestore.instance.collection('books').doc(docId).update({
          'price': (random % 100) + 10.0,
          'averageRating': ((random % 50) / 10.0),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Sample book added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error adding book: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔍 Firestore Queries'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This demo shows Firestore query capabilities:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('✅ WHERE filters (equality, comparison)'),
              Text('✅ ORDER BY sorting'),
              Text('✅ LIMIT pagination'),
              Text('✅ Array filters (arrayContains)'),
              Text('✅ Combined queries'),
              Text('✅ Real-time updates with StreamBuilder'),
              SizedBox(height: 12),
              Text(
                'Try different filters and see results update instantly!',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
