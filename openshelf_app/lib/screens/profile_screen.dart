import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// ============================================================================
/// PROFILE SCREEN - RECEIVING COMPLEX ARGUMENTS
/// ============================================================================
///
/// Demonstrates:
/// - Receiving complex arguments (Map)
/// - Display user profile information
/// - Navigation between screens
/// - Back navigation with pop()
///
/// ============================================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive complex arguments (Map) from previous screen
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final name = arguments?['name'] as String? ?? 'Unknown User';
    final navigationCount = arguments?['count'] as int? ?? 0;
    final fromScreen = arguments?['from'] as String? ?? 'Navigation Hub';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        centerTitle: true,
        elevation: 8,
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              // ================================================================
              // PROFILE CARD
              // ================================================================
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green[400]!,
                      Colors.green[600]!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: Colors.green[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Flutter Developer',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ================================================================
              // PROFILE INFORMATION
              // ================================================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green[300]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      '👤 Name',
                      name,
                      Colors.green[700]!,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      '📍 From Screen',
                      fromScreen,
                      Colors.green[700]!,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      '🔄 Navigation Count',
                      '$navigationCount',
                      Colors.green[700]!,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      '📅 Last Visit',
                      DateTime.now().toString().split('.')[0],
                      Colors.green[700]!,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ================================================================
              // RECEIVED ARGUMENTS INFO
              // ================================================================
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Received Arguments',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.amber[300]!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Map {',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Courier',
                              color: Colors.amber[900],
                            ),
                          ),
                          Text(
                            "  'name': '$name',",
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Courier',
                              color: Colors.amber[900],
                            ),
                          ),
                          Text(
                            "  'count': $navigationCount,",
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Courier',
                              color: Colors.amber[900],
                            ),
                          ),
                          Text(
                            "  'from': '$fromScreen',",
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Courier',
                              color: Colors.amber[900],
                            ),
                          ),
                          Text(
                            '}',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Courier',
                              color: Colors.amber[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '💡 Complex arguments (Maps) are passed between screens. The receiving screen extracts the data using ModalRoute.of().',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.amber[700],
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ================================================================
              // NAVIGATION BUTTONS
              // ================================================================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Go to Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[500],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Previous Screen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await AuthService().logout();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logged out'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
