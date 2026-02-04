import 'package:flutter/material.dart';
import 'widget_tree_demo.dart';
import 'stateless_stateful_demo.dart';

/// ============================================================================
/// DEMO HUB - TESTING CENTER FOR FLUTTER DEMONSTRATIONS
/// ============================================================================
///
/// A comprehensive testing and navigation hub for all Flutter demo screens.
/// Provides quick access to:
/// 1. Widget Tree & Reactive UI Demo
/// 2. Stateless vs Stateful Widgets Demo
/// 3. Hot Reload, Debug Console & DevTools Demo
///
/// This screen serves as the central testing point for developers to quickly
/// navigate between different demonstrations and verify functionality.
///
/// ============================================================================

class DemoHub extends StatefulWidget {
  const DemoHub({super.key});

  @override
  State<DemoHub> createState() => _DemoHubState();
}

class _DemoHubState extends State<DemoHub> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Flutter Demo Hub'),
        centerTitle: true,
        elevation: 8,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ================================================================
              // HEADER SECTION
              // ================================================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.deepPurple[300]!, Colors.deepPurple[600]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.dashboard, size: 48, color: Colors.white),
                    const SizedBox(height: 12),
                    const Text(
                      'Flutter Developer Tools Hub',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sprint #2: Testing & Demonstration Center',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ================================================================
              // DEMO CARDS SECTION
              // ================================================================
              Text(
                'Available Demonstrations',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
              ),

              const SizedBox(height: 16),

              // Demo Card 1: Widget Tree & Reactive UI
              _buildDemoCard(
                index: 0,
                title: '📊 Widget Tree & Reactive UI',
                subtitle: 'Understanding Flutter\'s Widget Hierarchy',
                description:
                    'Learn how Flutter\'s widget tree works and how setState() triggers reactive rebuilds. Explore the widget hierarchy with interactive examples.',
                icon: Icons.account_tree,
                color: Colors.blue,
                onTap: () => _navigateToDemo(context, const WidgetTreeDemo()),
              ),

              const SizedBox(height: 16),

              // Demo Card 2: Stateless vs Stateful
              _buildDemoCard(
                index: 1,
                title: '🎯 Stateless vs Stateful Widgets',
                subtitle: 'Comparing Widget Types',
                description:
                    'Understand the difference between StatelessWidget (immutable) and StatefulWidget (mutable). See real examples of each type in action.',
                icon: Icons.compare_arrows,
                color: Colors.purple,
                onTap: () =>
                    _navigateToDemo(context, const StatelessStatefulDemo()),
              ),

              const SizedBox(height: 16),

              // Demo Card 3: Scrollable Views
              _buildDemoCard(
                index: 2,
                title: '📜 Scrollable Views',
                subtitle: 'ListView & GridView Demonstrations',
                description:
                    'Master scrollable layouts with ListView and GridView. Learn how to build efficient, dynamic lists and grids for displaying large datasets.',
                icon: Icons.view_list,
                color: Colors.teal,
                onTap: () => Navigator.pushNamed(context, '/scrollable-views'),
              ),

              const SizedBox(height: 16),

              // Demo Card 4: User Input Form
              _buildDemoCard(
                index: 3,
                title: '📝 User Input & Forms',
                subtitle: 'TextFields, Validation & Form State',
                description:
                    'Learn to handle user input with TextFields, implement form validation, and manage form state. Master input widgets and user feedback.',
                icon: Icons.edit_document,
                color: Colors.orange,
                onTap: () => Navigator.pushNamed(context, '/user-input-form'),
              ),

              const SizedBox(height: 16),

              // Demo Card 5: State Management with setState
              _buildDemoCard(
                index: 4,
                title: '⚡ State Management',
                subtitle: 'setState() & Stateful Logic',
                description:
                    'Master local state management with setState(). Learn how to build reactive UIs that respond to user interactions and data changes.',
                icon: Icons.settings_suggest,
                color: Colors.green,
                onTap: () =>
                    Navigator.pushNamed(context, '/state-management-demo'),
              ),
              const SizedBox(height: 16),

              // Demo Card 6: Firestore Read Operations
              _buildDemoCard(
                index: 5,
                title: '🔥 Firestore Read Operations',
                subtitle: 'Real-Time Data from Cloud Firestore',
                description:
                    'Learn to read data from Firestore collections using StreamBuilder and FutureBuilder. Display live data that updates automatically.',
                icon: Icons.cloud_sync,
                color: Colors.red,
                onTap: () =>
                    Navigator.pushNamed(context, '/firestore-read-demo'),
              ),
              const SizedBox(height: 32),

              // ================================================================
              // TESTING GUIDELINES SECTION
              // ================================================================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  border: Border.all(color: Colors.amber[400]!, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.amber[700], size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Testing Guidelines',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '✓ Tap buttons and observe state changes\n'
                      '✓ Watch Debug Console for debugPrint() output\n'
                      '✓ Use Hot Reload (press "r") to test UI changes\n'
                      '✓ Open DevTools to inspect Widget Tree\n'
                      '✓ Check Performance tab for rebuild metrics',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.amber[900],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ================================================================
              // QUICK STATS SECTION
              // ================================================================
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      label: 'Demo Screens',
                      value: '6',
                      icon: Icons.widgets,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      label: 'Components',
                      value: '25+',
                      icon: Icons.layers,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      label: 'Features',
                      value: '35+',
                      icon: Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ================================================================
              // DEVELOPER NOTES SECTION
              // ================================================================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📝 Developer Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildNoteItem(
                      title: 'Hot Reload Usage',
                      description:
                          'Press "r" after code changes to see updates instantly',
                    ),
                    const SizedBox(height: 8),
                    _buildNoteItem(
                      title: 'Debug Output',
                      description:
                          'Check terminal for debugPrint() messages when interacting',
                    ),
                    const SizedBox(height: 8),
                    _buildNoteItem(
                      title: 'DevTools',
                      description:
                          'Open DevTools (Ctrl+Shift+P → DevTools) to inspect widgets',
                    ),
                    const SizedBox(height: 8),
                    _buildNoteItem(
                      title: 'Performance',
                      description:
                          'Use DevTools Performance tab to monitor frame rates',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ================================================================
              // ACTION BUTTONS SECTION
              // ================================================================
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _navigateToDemo(context, const WidgetTreeDemo()),
                      icon: const Icon(Icons.account_tree),
                      label: const Text('Widget Tree Demo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToDemo(
                        context,
                        const StatelessStatefulDemo(),
                      ),
                      icon: const Icon(Icons.compare_arrows),
                      label: const Text('Widgets Demo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  /// Build individual demo card
  Widget _buildDemoCard({
    required int index,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, color: color, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: color, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build stat card
  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build developer note item
  Widget _buildNoteItem({required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: Colors.grey[600],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Navigate to demo screen
  void _navigateToDemo(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }
}
