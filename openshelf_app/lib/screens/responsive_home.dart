import 'package:flutter/material.dart';

class ResponsiveHome extends StatefulWidget {
  const ResponsiveHome({super.key});

  @override
  State<ResponsiveHome> createState() => _ResponsiveHomeState();
}

class _ResponsiveHomeState extends State<ResponsiveHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get device dimensions and orientation
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: _buildAppBar(isTablet),
      body: isPortrait
          ? _buildPortraitLayout(context, screenWidth, screenHeight, isTablet)
          : _buildLandscapeLayout(context, screenWidth, screenHeight, isTablet),
      bottomNavigationBar: isTablet ? null : _buildBottomNav(),
      drawer: isTablet ? null : _buildDrawer(),
    );
  }

  // Build AppBar
  PreferredSizeWidget _buildAppBar(bool isTablet) {
    return AppBar(
      title: Text(
        'OpenShelf Resources',
        style: TextStyle(
          fontSize: isTablet ? 24 : 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.deepPurple,
      elevation: 4,
      centerTitle: isTablet,
    );
  }

  // Build Portrait Layout (Phone)
  Widget _buildPortraitLayout(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section
          _buildHeaderSection(screenWidth, screenHeight, isTablet),

          // Content Grid
          _buildContentGrid(screenWidth, isTablet),

          // Feature Cards
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24.0 : 16.0,
              vertical: isTablet ? 20.0 : 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Featured Resources',
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 12),
                _buildFeatureCard(screenWidth, isTablet, 'Books', Icons.book),
                _buildFeatureCard(
                    screenWidth, isTablet, 'Courses', Icons.school),
                _buildFeatureCard(screenWidth, isTablet, 'Articles', Icons.article),
              ],
            ),
          ),

          // Footer Section
          _buildFooterSection(screenWidth, isTablet),
        ],
      ),
    );
  }

  // Build Landscape Layout (Tablet/Wide)
  Widget _buildLandscapeLayout(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Row(
      children: [
        // Sidebar for Landscape
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.deepPurple.shade100,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderSection(screenWidth / 2, screenHeight, isTablet),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildFeatureCard(
                            screenWidth / 2.2, isTablet, 'Books', Icons.book),
                        _buildFeatureCard(screenWidth / 2.2, isTablet, 'Courses',
                            Icons.school),
                        _buildFeatureCard(screenWidth / 2.2, isTablet, 'Articles',
                            Icons.article),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Main Content for Landscape
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Explore Resources',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                _buildContentGrid(screenWidth * 0.5, isTablet),
                _buildFooterSection(screenWidth * 0.5, isTablet),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Build Header Section
  Widget _buildHeaderSection(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.0 : 16.0,
        vertical: isTablet ? 20.0 : 16.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to OpenShelf',
            style: TextStyle(
              fontSize: isTablet ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            'Discover and share knowledge across all devices',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // Build Content Grid
  Widget _buildContentGrid(
    double screenWidth,
    bool isTablet,
  ) {
    final gridItems = ['Resource 1', 'Resource 2', 'Resource 3', 'Resource 4'];
    final crossAxisCount = isTablet ? 2 : 1;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.0 : 16.0,
        vertical: isTablet ? 20.0 : 16.0,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1.2,
          crossAxisSpacing: isTablet ? 16.0 : 12.0,
          mainAxisSpacing: isTablet ? 16.0 : 12.0,
        ),
        itemCount: gridItems.length,
        itemBuilder: (context, index) {
          return _buildGridCard(gridItems[index], index);
        },
      ),
    );
  }

  // Build Individual Grid Card
  Widget _buildGridCard(String title, int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: colors[index],
        ),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.7,
              child: Container(
                color: colors[index],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  [Icons.book, Icons.school, Icons.article, Icons.videocam]
                      [index],
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build Feature Card
  Widget _buildFeatureCard(double width, bool isTablet, String label, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: isTablet ? 12.0 : 8.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.deepPurple),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 16 : 14,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward, color: Colors.deepPurple),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped: $label')),
        ),
      ),
    );
  }

  // Build Footer Section
  Widget _buildFooterSection(double screenWidth, bool isTablet) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.0 : 16.0,
        vertical: isTablet ? 24.0 : 20.0,
      ),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get Started',
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 16 : 12,
                ),
              ),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Let\'s explore resources!')),
              ),
              child: Text(
                'Explore Now',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Text(
            '© 2026 OpenShelf. All rights reserved.',
            style: TextStyle(
              fontSize: isTablet ? 13 : 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Build Bottom Navigation
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (index) => setState(() => _selectedIndex = index),
    );
  }

  // Build Drawer
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.library_books, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'OpenShelf Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: const Text('Browse'),
            leading: const Icon(Icons.browse_gallery),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
