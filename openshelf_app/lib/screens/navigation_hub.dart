import 'package:flutter/material.dart';

/// ============================================================================
/// NAVIGATION HUB - CENTRAL NAVIGATION POINT
/// ============================================================================
///
/// This is the main navigation hub that demonstrates multi-screen navigation
/// using Navigator and named routes.
///
/// Features:
/// - Navigate to different screens using named routes
/// - Pass arguments between screens
/// - Handle back navigation
/// - Display user information
///
/// ============================================================================

class NavigationHub extends StatefulWidget {
  const NavigationHub({super.key});

  @override
  State<NavigationHub> createState() => _NavigationHubState();
}

class _NavigationHubState extends State<NavigationHub> {
  String _userName = 'Flutter Developer';
  int _navigationCount = 0;

  void _recordNavigation() {
    setState(() {
      _navigationCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Hub'),
        centerTitle: true,
        elevation: 8,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              // ================================================================
              // WELCOME SECTION
              // ================================================================
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple[300]!,
                      Colors.deepPurple[600]!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.dashboard,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome, $_userName!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Navigation Count: $_navigationCount',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '🧭 Multi-Screen Navigation Demo\nNavigate between screens using named routes',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ================================================================
              // NAVIGATION BUTTONS
              // ================================================================
              Text(
                'Available Screens',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
              ),

              const SizedBox(height: 16),

              // Home Screen Button
              _buildNavigationButton(
                label: 'Home Screen',
                icon: Icons.home,
                color: Colors.blue[500]!,
                onPressed: () {
                  _recordNavigation();
                  Navigator.pushNamed(
                    context,
                    '/home',
                    arguments: _userName,
                  );
                },
              ),

              const SizedBox(height: 12),

              // Profile Screen Button
              _buildNavigationButton(
                label: 'Profile Screen',
                icon: Icons.person,
                color: Colors.green[500]!,
                onPressed: () {
                  _recordNavigation();
                  Navigator.pushNamed(
                    context,
                    '/profile',
                    arguments: {'name': _userName, 'count': _navigationCount},
                  );
                },
              ),

              const SizedBox(height: 12),

              // Settings Screen Button
              _buildNavigationButton(
                label: 'Settings Screen',
                icon: Icons.settings,
                color: Colors.orange[500]!,
                onPressed: () {
                  _recordNavigation();
                  Navigator.pushNamed(context, '/settings');
                },
              ),

              const SizedBox(height: 12),

              // About Screen Button
              _buildNavigationButton(
                label: 'About Screen',
                icon: Icons.info,
                color: Colors.purple[500]!,
                onPressed: () {
                  _recordNavigation();
                  Navigator.pushNamed(context, '/about');
                },
              ),

              const SizedBox(height: 32),

              // ================================================================
              // HOW NAVIGATION WORKS
              // ================================================================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue[300]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'How Navigation Works',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      '1. Named Routes',
                      'Routes are defined in main.dart with path names like /home, /profile',
                      Colors.blue[700]!,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoItem(
                      '2. Navigator.pushNamed()',
                      'Navigates to a new screen and adds it to the stack',
                      Colors.blue[700]!,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoItem(
                      '3. Navigator.pop()',
                      'Goes back to the previous screen in the stack',
                      Colors.blue[700]!,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoItem(
                      '4. Pass Arguments',
                      'Send data between screens using arguments parameter',
                      Colors.blue[700]!,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Change Name Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber[300]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Update Your Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[900],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _userName = value.isEmpty ? 'Flutter Developer' : value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current: $_userName',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber[800],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
