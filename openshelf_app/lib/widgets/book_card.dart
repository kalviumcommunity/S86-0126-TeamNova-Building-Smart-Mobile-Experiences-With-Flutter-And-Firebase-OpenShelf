import 'package:flutter/material.dart';

/// ============================================================================
/// BOOK CARD - REUSABLE WIDGET
/// ============================================================================
///
/// A reusable card widget specifically designed for displaying book information
/// in the OpenShelf app.
///
/// Features:
/// - Displays book title, author, and rating
/// - Includes a favorite button (stateful)
/// - Shows book cover placeholder
/// - Customizable tap action
///
/// ============================================================================

class BookCard extends StatefulWidget {
  final String title;
  final String author;
  final double rating;
  final String? coverUrl;
  final VoidCallback? onTap;
  final bool initialFavorite;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    this.rating = 0.0,
    this.coverUrl,
    this.onTap,
    this.initialFavorite = false,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? '${widget.title} added to favorites!'
              : '${widget.title} removed from favorites',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Cover
              Container(
                width: 80,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                  image: widget.coverUrl != null
                      ? DecorationImage(
                          image: NetworkImage(widget.coverUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.coverUrl == null
                    ? const Icon(Icons.book, size: 40, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12),

              // Book Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'by ${widget.author}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          widget.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite Button
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
