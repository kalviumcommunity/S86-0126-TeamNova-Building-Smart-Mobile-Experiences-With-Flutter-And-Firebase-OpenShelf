import 'package:flutter/material.dart';

/// ============================================================================
/// RESPONSIVE DASHBOARD - Real-World Implementation
/// ============================================================================
///
/// This screen demonstrates a real-world responsive dashboard that adapts
/// to different screen sizes using MediaQuery and LayoutBuilder.
///
/// Features:
/// - Stats cards that reflow based on screen width
/// - Adaptive navigation (bottom bar vs side rail)
/// - Responsive book grid (2/3/4 columns)
/// - Context-aware spacing and typography
///
/// ============================================================================

class ResponsiveDashboard extends StatefulWidget {
  const ResponsiveDashboard({super.key});

  @override
  State<ResponsiveDashboard> createState() => _ResponsiveDashboardState();
}

class _ResponsiveDashboardState extends State<ResponsiveDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we're on a large screen
        final isLargeScreen = constraints.maxWidth >= 600;

        return Scaffold(
          appBar: AppBar(
            title: const Text('OpenShelf Dashboard'),
            centerTitle: !isLargeScreen,
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
            ],
          ),
          body: Row(
            children: [
              // Side navigation for large screens
              if (isLargeScreen)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Colors.grey[100],
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.book_outlined),
                      selectedIcon: Icon(Icons.book),
                      label: Text('Library'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_outline),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                ),

              // Main content
              Expanded(
                child: _buildDashboardContent(context, isLargeScreen),
              ),
            ],
          ),
          // Bottom navigation for small screens
          bottomNavigationBar: isLargeScreen
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: 'Dashboard',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.book_outlined),
                      selectedIcon: Icon(Icons.book),
                      label: 'Library',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.favorite_outline),
                      selectedIcon: Icon(Icons.favorite),
                      label: 'Favorites',
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildDashboardContent(BuildContext context, bool isLargeScreen) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================================================================
            // WELCOME SECTION
            // ================================================================
            Text(
              'Welcome back!',
              style: TextStyle(
                fontSize: isLargeScreen ? 32 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Here\'s what\'s happening with your reading',
              style: TextStyle(
                fontSize: isLargeScreen ? 16 : 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: isLargeScreen ? 32 : 24),

            // ================================================================
            // STATS CARDS (Responsive Grid)
            // ================================================================
            LayoutBuilder(
              builder: (context, constraints) {
                // Determine grid columns based on width
                int columns;
                if (constraints.maxWidth < 600) {
                  columns = 2; // Mobile: 2 columns
                } else if (constraints.maxWidth < 900) {
                  columns = 3; // Tablet: 3 columns
                } else {
                  columns = 4; // Desktop: 4 columns
                }

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isLargeScreen ? 1.3 : 1.1,
                  children: [
                    _buildStatCard(
                      'Total Books',
                      '127',
                      Icons.library_books,
                      Colors.blue,
                      '+12 this month',
                    ),
                    _buildStatCard(
                      'Reading',
                      '8',
                      Icons.menu_book,
                      Colors.orange,
                      '3 nearly done',
                    ),
                    _buildStatCard(
                      'Completed',
                      '89',
                      Icons.check_circle,
                      Colors.green,
                      '+15% vs last month',
                    ),
                    _buildStatCard(
                      'Wish List',
                      '30',
                      Icons.bookmark,
                      Colors.purple,
                      '5 new additions',
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: isLargeScreen ? 32 : 24),

            // ================================================================
            // CURRENTLY READING SECTION
            // ================================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Currently Reading',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 24 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Adaptive book list layout
            LayoutBuilder(
              builder: (context, constraints) {
                if (isLargeScreen) {
                  // Tablet: Horizontal scrolling list
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 16),
                          child: _buildBookCard(index),
                        );
                      },
                    ),
                  );
                } else {
                  // Mobile: Vertical list
                  return Column(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildHorizontalBookCard(index),
                      ),
                    ),
                  );
                }
              },
            ),

            SizedBox(height: isLargeScreen ? 32 : 24),

            // ================================================================
            // RECOMMENDATIONS SECTION
            // ================================================================
            Text(
              'Recommended for You',
              style: TextStyle(
                fontSize: isLargeScreen ? 24 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Responsive grid for recommendations
            LayoutBuilder(
              builder: (context, constraints) {
                int columns;
                if (constraints.maxWidth < 500) {
                  columns = 2;
                } else if (constraints.maxWidth < 800) {
                  columns = 3;
                } else {
                  columns = 4;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return _buildBookCard(index);
                  },
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.7),
            color,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(int index) {
    final books = [
      'The Great Gatsby',
      'To Kill a Mockingbird',
      '1984',
      'Pride and Prejudice',
      'The Catcher in the Rye',
      'Animal Farm',
    ];

    final authors = [
      'F. Scott Fitzgerald',
      'Harper Lee',
      'George Orwell',
      'Jane Austen',
      'J.D. Salinger',
      'George Orwell',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book cover
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Center(
                child: Icon(Icons.book, size: 48, color: Colors.grey),
              ),
            ),
          ),
          // Book info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        books[index % books.length],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authors[index % authors.length],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      SizedBox(width: 4),
                      Text('4.5', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalBookCard(int index) {
    final books = [
      'The Midnight Library',
      'Atomic Habits',
      'Project Hail Mary',
    ];

    final authors = [
      'Matt Haig',
      'James Clear',
      'Andy Weir',
    ];

    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Book cover
          Container(
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.book, size: 40, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          // Book info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  books[index],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  authors[index],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    SizedBox(width: 4),
                    Text('4.5', style: TextStyle(fontSize: 14)),
                    Spacer(),
                    Text('67% complete', style: TextStyle(fontSize: 12, color: Colors.teal)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
