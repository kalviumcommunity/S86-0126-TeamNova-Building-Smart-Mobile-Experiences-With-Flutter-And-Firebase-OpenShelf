import 'package:flutter/material.dart';

/// ============================================================================
/// RESPONSIVE DESIGN DEMO - MediaQuery & LayoutBuilder
/// ============================================================================
///
/// This screen demonstrates responsive design techniques using:
/// 1. MediaQuery - for accessing device dimensions and metrics
/// 2. LayoutBuilder - for building conditional layouts based on constraints
///
/// Features:
/// - Adaptive layout (mobile vs tablet)
/// - Responsive sizing using percentages
/// - Orientation handling
/// - Breakpoint-based design
///
/// ============================================================================

class ResponsiveDesignDemo extends StatelessWidget {
  const ResponsiveDesignDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Get device information using MediaQuery
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final orientation = mediaQuery.orientation;
    final devicePixelRatio = mediaQuery.devicePixelRatio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Design Demo'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ================================================================
            // SECTION 1: DEVICE INFORMATION (MediaQuery)
            // ================================================================
            Container(
              color: Colors.teal.withOpacity(0.1),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📱 Device Information (MediaQuery)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Screen Width', '${screenWidth.toStringAsFixed(2)} px'),
                  _buildInfoRow('Screen Height', '${screenHeight.toStringAsFixed(2)} px'),
                  _buildInfoRow('Orientation', orientation.toString().split('.').last),
                  _buildInfoRow('Pixel Ratio', devicePixelRatio.toString()),
                  _buildInfoRow('Device Type', screenWidth < 600 ? 'Mobile' : 'Tablet'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================================================================
            // SECTION 2: RESPONSIVE CONTAINERS (MediaQuery Percentage)
            // ================================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📏 Responsive Sizing (Percentage-based)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 80% width container
                  Container(
                    width: screenWidth * 0.8,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '80% Screen Width',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // 60% width container
                  Container(
                    width: screenWidth * 0.6,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '60% Screen Width',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // 40% width container
                  Container(
                    width: screenWidth * 0.4,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '40% Width',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================================================================
            // SECTION 3: ADAPTIVE LAYOUT (LayoutBuilder)
            // ================================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔄 Adaptive Layout (LayoutBuilder)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // LayoutBuilder for adaptive layout
            LayoutBuilder(
              builder: (context, constraints) {
                // Breakpoint: 600px
                final isMobile = constraints.maxWidth < 600;

                if (isMobile) {
                  // MOBILE LAYOUT (Column)
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildColorCard(
                          'Mobile View',
                          'Layout: Column',
                          Colors.purple,
                          Icons.phone_android,
                        ),
                        const SizedBox(height: 12),
                        _buildColorCard(
                          'Stacked Cards',
                          'For narrow screens',
                          Colors.deepPurple,
                          Icons.view_agenda,
                        ),
                        const SizedBox(height: 12),
                        _buildColorCard(
                          'Vertical Layout',
                          'Width < 600px',
                          Colors.indigo,
                          Icons.vertical_distribute,
                        ),
                      ],
                    ),
                  );
                } else {
                  // TABLET LAYOUT (Row)
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildColorCard(
                            'Tablet View',
                            'Layout: Row',
                            Colors.teal,
                            Icons.tablet_android,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildColorCard(
                            'Side by Side',
                            'For wide screens',
                            Colors.cyan,
                            Icons.view_week,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildColorCard(
                            'Horizontal Layout',
                            'Width ≥ 600px',
                            Colors.blue,
                            Icons.horizontal_distribute,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 24),

            // ================================================================
            // SECTION 4: GRID LAYOUT (Responsive Columns)
            // ================================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 Responsive Grid',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            LayoutBuilder(
              builder: (context, constraints) {
                // Determine number of columns based on width
                int crossAxisCount;
                if (constraints.maxWidth < 600) {
                  crossAxisCount = 2; // Mobile: 2 columns
                } else if (constraints.maxWidth < 900) {
                  crossAxisCount = 3; // Tablet: 3 columns
                } else {
                  crossAxisCount = 4; // Desktop: 4 columns
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _getGridColor(index).withOpacity(0.7),
                              _getGridColor(index),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getGridIcon(index),
                              size: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Item ${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$crossAxisCount cols',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ================================================================
            // SECTION 5: RESPONSIVE TEXT
            // ================================================================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📝 Responsive Typography',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adaptive Font Size',
                          style: TextStyle(
                            fontSize: screenWidth < 600 ? 20 : 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This text scales based on screen width. '
                          'On mobile devices, it\'s ${screenWidth < 600 ? "20px" : "28px"} for better readability.',
                          style: TextStyle(
                            fontSize: screenWidth < 600 ? 14 : 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCard(String title, String subtitle, Color color, IconData icon) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.7),
            color,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGridColor(int index) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.green,
      Colors.blue,
      Colors.purple,
    ];
    return colors[index % colors.length];
  }

  IconData _getGridIcon(int index) {
    final icons = [
      Icons.home,
      Icons.star,
      Icons.favorite,
      Icons.settings,
      Icons.person,
      Icons.book,
    ];
    return icons[index % icons.length];
  }
}
