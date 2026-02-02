import 'package:flutter/material.dart';

// Import custom widgets
import '../widgets/custom_button.dart';
import '../widgets/book_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/feature_tile.dart';

/// ============================================================================
/// LIBRARY SCREEN - DEMONSTRATES WIDGET REUSABILITY
/// ============================================================================
///
/// This screen shows how the same custom widgets can be reused multiple times
/// within a single screen with different data and configurations.
///
/// Custom Widgets Reused:
/// - StatsCard (4 instances with different stats)
/// - BookCard (6 instances with different books)
/// - FeatureTile (3 instances with different features)
/// - CustomButton (2 instances with different actions)
///
/// ============================================================================

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search functionality')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================================================================
            // STATISTICS SECTION - REUSING STATS CARD 4 TIMES
            // ================================================================
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Reading Stats',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // StatsCard instance 1
                      Expanded(
                        child: StatsCard(
                          label: 'Total Books',
                          value: '127',
                          icon: Icons.library_books,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // StatsCard instance 2
                      Expanded(
                        child: StatsCard(
                          label: 'Currently Reading',
                          value: '8',
                          icon: Icons.menu_book,
                          color: Colors.orange,
                          trend: '+2',
                          isTrendPositive: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // StatsCard instance 3
                      Expanded(
                        child: StatsCard(
                          label: 'Completed',
                          value: '89',
                          icon: Icons.check_circle,
                          color: Colors.green,
                          trend: '+15%',
                          isTrendPositive: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // StatsCard instance 4
                      Expanded(
                        child: StatsCard(
                          label: 'Wish List',
                          value: '30',
                          icon: Icons.bookmark,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================================================================
            // QUICK ACTIONS - REUSING FEATURE TILE 3 TIMES
            // ================================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // FeatureTile instance 1
                  FeatureTile(
                    title: 'Add New Book',
                    subtitle: 'Scan or manually add books',
                    icon: Icons.add_circle,
                    iconColor: Colors.teal,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add new book')),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  
                  // FeatureTile instance 2
                  FeatureTile(
                    title: 'Reading Goals',
                    subtitle: 'Track your progress',
                    icon: Icons.flag,
                    iconColor: Colors.orange,
                    badgeCount: 3,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('View reading goals')),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  
                  // FeatureTile instance 3
                  FeatureTile(
                    title: 'Book Clubs',
                    subtitle: 'Join community discussions',
                    icon: Icons.groups,
                    iconColor: Colors.purple,
                    badgeCount: 12,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('View book clubs')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================================================================
            // CURRENTLY READING - REUSING BOOK CARD 3 TIMES
            // ================================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Currently Reading',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('View all books')),
                          );
                        },
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // BookCard instance 1
            BookCard(
              title: 'The Midnight Library',
              author: 'Matt Haig',
              rating: 4.2,
              initialFavorite: true,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening: The Midnight Library')),
                );
              },
            ),
            
            // BookCard instance 2
            BookCard(
              title: 'Atomic Habits',
              author: 'James Clear',
              rating: 4.7,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening: Atomic Habits')),
                );
              },
            ),
            
            // BookCard instance 3
            BookCard(
              title: 'Project Hail Mary',
              author: 'Andy Weir',
              rating: 4.6,
              initialFavorite: true,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening: Project Hail Mary')),
                );
              },
            ),

            const SizedBox(height: 24),

            // ================================================================
            // RECOMMENDED - REUSING BOOK CARD 3 MORE TIMES
            // ================================================================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recommended for You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // BookCard instance 4
            BookCard(
              title: 'The Seven Husbands of Evelyn Hugo',
              author: 'Taylor Jenkins Reid',
              rating: 4.4,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Opening: The Seven Husbands of Evelyn Hugo')),
                );
              },
            ),
            
            // BookCard instance 5
            BookCard(
              title: 'Where the Crawdads Sing',
              author: 'Delia Owens',
              rating: 4.5,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Opening: Where the Crawdads Sing')),
                );
              },
            ),
            
            // BookCard instance 6
            BookCard(
              title: 'The Silent Patient',
              author: 'Alex Michaelides',
              rating: 4.1,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening: The Silent Patient')),
                );
              },
            ),

            const SizedBox(height: 24),

            // ================================================================
            // ACTION BUTTONS - REUSING CUSTOM BUTTON 2 TIMES
            // ================================================================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // CustomButton instance 1
                  CustomButton(
                    label: 'Browse All Books',
                    icon: Icons.explore,
                    color: Colors.teal,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Browse all books')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // CustomButton instance 2
                  CustomButton(
                    label: 'View Reading Statistics',
                    icon: Icons.analytics,
                    color: Colors.blue,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('View detailed statistics')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add new book to library')),
          );
        },
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
      ),
    );
  }
}
