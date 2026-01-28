import 'package:flutter/material.dart';

class ResponsiveLayout extends StatefulWidget {
  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive Layout Dashboard'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📱 HEADER SECTION - Full Width
                _buildHeaderSection(screenWidth, isMobile),
                SizedBox(height: isMobile ? 16 : 24),

                // 📊 STATS SECTION - Responsive Grid
                _buildStatsSection(screenWidth, isMobile, isTablet),
                SizedBox(height: isMobile ? 16 : 24),

                // 🎯 CONTENT SECTION - Adaptive Layout
                if (isMobile)
                  _buildMobileLayout()
                else if (isTablet)
                  _buildTabletLayout()
                else
                  _buildDesktopLayout(),

                SizedBox(height: 20),

                // 📋 RESPONSIVE DETAILS
                _buildDetailsSection(screenWidth, isMobile),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // 🎨 HEADER SECTION
  Widget _buildHeaderSection(double screenWidth, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple, Colors.purpleAccent],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to OpenShelf',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Screen Width: ${screenWidth.toStringAsFixed(0)}px',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.dashboard,
                  color: Colors.white,
                  size: isMobile ? 24 : 32,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            'Responsive design adapts beautifully to all screen sizes. Try rotating your device!',
            style: TextStyle(
              fontSize: isMobile ? 13 : 15,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 📊 STATS SECTION - Responsive Cards
  Widget _buildStatsSection(double screenWidth, bool isMobile, bool isTablet) {
    final statCards = [
      {'title': 'Books', 'value': '1,250', 'icon': Icons.library_books, 'color': Colors.blue},
      {'title': 'Users', 'value': '8,430', 'icon': Icons.people, 'color': Colors.green},
      {'title': 'Reviews', 'value': '5,280', 'icon': Icons.star, 'color': Colors.orange},
      {'title': 'Active', 'value': '92%', 'icon': Icons.trending_up, 'color': Colors.red},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: TextStyle(
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : (isTablet ? 3 : 4),
            childAspectRatio: 1.2,
            crossAxisSpacing: isMobile ? 12 : 16,
            mainAxisSpacing: isMobile ? 12 : 16,
          ),
          itemCount: statCards.length,
          itemBuilder: (context, index) {
            final stat = statCards[index];
            return _buildStatCard(
              title: stat['title'] as String,
              value: stat['value'] as String,
              icon: stat['icon'] as IconData,
              color: stat['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  // 📈 STAT CARD
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // 📱 MOBILE LAYOUT - Single Column
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layout: Mobile (Single Column)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        _buildContentCard(
          title: 'Featured Book',
          icon: Icons.menu_book,
          color: Colors.blue,
          content: 'Books are displayed in a single column for easy scrolling on mobile devices.',
        ),
        SizedBox(height: 12),
        _buildContentCard(
          title: 'User Profile',
          icon: Icons.person,
          color: Colors.green,
          content: 'Profile information stacks vertically for optimal mobile viewing.',
        ),
        SizedBox(height: 12),
        _buildContentCard(
          title: 'Recommendations',
          icon: Icons.lightbulb,
          color: Colors.orange,
          content: 'Personalized suggestions adapt to your reading preferences.',
        ),
      ],
    );
  }

  // 📱 TABLET LAYOUT - Two Columns
  Widget _buildTabletLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layout: Tablet (Two Columns)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildContentCard(
                title: 'Featured Book',
                icon: Icons.menu_book,
                color: Colors.blue,
                content: 'Left column displays featured books with covers.',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildContentCard(
                title: 'User Profile',
                icon: Icons.person,
                color: Colors.green,
                content: 'Right column shows user profile information.',
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildContentCard(
          title: 'Recommendations',
          icon: Icons.lightbulb,
          color: Colors.orange,
          content: 'Full-width row for personalized suggestions.',
        ),
      ],
    );
  }

  // 🖥️ DESKTOP LAYOUT - Three Columns
  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layout: Desktop (Three Columns)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildContentCard(
                title: 'Featured Book',
                icon: Icons.menu_book,
                color: Colors.blue,
                content: 'First column displays featured books.',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildContentCard(
                title: 'User Profile',
                icon: Icons.person,
                color: Colors.green,
                content: 'Second column shows profile info.',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildContentCard(
                title: 'Recommendations',
                icon: Icons.lightbulb,
                color: Colors.orange,
                content: 'Third column with suggestions.',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 🎨 CONTENT CARD WIDGET
  Widget _buildContentCard({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 📋 DETAILS SECTION
  Widget _buildDetailsSection(double screenWidth, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Text(
                'Responsive Design Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildDetailPoint('📱 Mobile', '< 600px', 'Single column layout for easy scrolling'),
          SizedBox(height: 8),
          _buildDetailPoint('📱 Tablet', '600px - 1200px', 'Two to three column adaptive layout'),
          SizedBox(height: 8),
          _buildDetailPoint('🖥️ Desktop', '≥ 1200px', 'Full multi-column dashboard view'),
          SizedBox(height: 8),
          _buildDetailPoint('🔄 Responsive', 'MediaQuery', 'Widgets use MediaQuery.of(context).size'),
          SizedBox(height: 8),
          _buildDetailPoint('📐 Alignment', 'Flexible', 'Uses Expanded, Row, Column with proper spacing'),
        ],
      ),
    );
  }

  // 📌 DETAIL POINT
  Widget _buildDetailPoint(String device, String breakpoint, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$device ($breakpoint): ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    fontSize: 12,
                  ),
                ),
                TextSpan(
                  text: description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 🔘 BOTTOM NAVIGATION BAR
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Books',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
