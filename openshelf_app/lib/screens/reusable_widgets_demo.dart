import 'package:flutter/material.dart';

// Import custom widgets
import '../widgets/custom_button.dart';
import '../widgets/info_card.dart';
import '../widgets/book_card.dart';
import '../widgets/feature_tile.dart';
import '../widgets/stats_card.dart';

/// ============================================================================
/// REUSABLE WIDGETS DEMO - SHOWCASING CUSTOM WIDGETS
/// ============================================================================
///
/// This screen demonstrates the use of custom reusable widgets throughout
/// the OpenShelf application.
///
/// Custom Widgets Used:
/// - CustomButton: Reusable button with icon and customization
/// - InfoCard: Information display card with icon
/// - BookCard: Book display with favorite functionality
/// - FeatureTile: Feature/option tile with navigation
/// - StatsCard: Statistical information display
///
/// ============================================================================

class ReusableWidgetsDemo extends StatelessWidget {
  const ReusableWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reusable Custom Widgets'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================================================================
            // SECTION 1: CUSTOM BUTTONS
            // ================================================================
            const Text(
              '1. Custom Buttons',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            CustomButton(
              label: 'Add to Library',
              icon: Icons.add,
              color: Colors.teal,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to library!')),
                );
              },
            ),
            const SizedBox(height: 12),
            
            CustomButton(
              label: 'View Details',
              icon: Icons.info_outline,
              color: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            const SizedBox(height: 12),
            
            CustomButton(
              label: 'Delete',
              icon: Icons.delete_outline,
              color: Colors.red,
              isOutlined: true,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Delete action')),
                );
              },
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // ================================================================
            // SECTION 2: INFO CARDS
            // ================================================================
            const Text(
              '2. Info Cards',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            InfoCard(
              title: 'My Profile',
              subtitle: 'View and edit your account details',
              icon: Icons.person,
              iconColor: Colors.teal,
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            
            InfoCard(
              title: 'Reading List',
              subtitle: '15 books currently reading',
              icon: Icons.menu_book,
              iconColor: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening reading list...')),
                );
              },
            ),
            
            InfoCard(
              title: 'Achievements',
              subtitle: 'Unlock badges and rewards',
              icon: Icons.emoji_events,
              iconColor: Colors.amber,
              useGradient: true,
              cardColor: Colors.purple,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening achievements...')),
                );
              },
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // ================================================================
            // SECTION 3: BOOK CARDS
            // ================================================================
            const Text(
              '3. Book Cards',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            BookCard(
              title: 'The Great Gatsby',
              author: 'F. Scott Fitzgerald',
              rating: 4.5,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening book details...')),
                );
              },
            ),
            
            BookCard(
              title: 'To Kill a Mockingbird',
              author: 'Harper Lee',
              rating: 4.8,
              initialFavorite: true,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening book details...')),
                );
              },
            ),
            
            BookCard(
              title: '1984',
              author: 'George Orwell',
              rating: 4.6,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening book details...')),
                );
              },
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // ================================================================
            // SECTION 4: FEATURE TILES
            // ================================================================
            const Text(
              '4. Feature Tiles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            FeatureTile(
              title: 'Notifications',
              subtitle: 'Manage your alerts',
              icon: Icons.notifications,
              iconColor: Colors.blue,
              badgeCount: 5,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening notifications...')),
                );
              },
            ),
            const SizedBox(height: 12),
            
            FeatureTile(
              title: 'Settings',
              subtitle: 'App preferences',
              icon: Icons.settings,
              iconColor: Colors.grey,
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const SizedBox(height: 12),
            
            FeatureTile(
              title: 'Help & Support',
              subtitle: 'Get assistance',
              icon: Icons.help,
              iconColor: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening help center...')),
                );
              },
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // ================================================================
            // SECTION 5: STATS CARDS
            // ================================================================
            const Text(
              '5. Stats Cards',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    label: 'Books Read',
                    value: '24',
                    icon: Icons.book,
                    color: Colors.teal,
                    trend: '+12%',
                    isTrendPositive: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    label: 'Reading Hours',
                    value: '156',
                    icon: Icons.access_time,
                    color: Colors.purple,
                    trend: '+8%',
                    isTrendPositive: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    label: 'Favorites',
                    value: '42',
                    icon: Icons.favorite,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    label: 'Reviews',
                    value: '18',
                    icon: Icons.star,
                    color: Colors.amber,
                    trend: '+5',
                    isTrendPositive: true,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
