import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ============================================================================
/// HOT RELOAD, DEBUG CONSOLE & DEVTOOLS DEMONSTRATION
/// ============================================================================
///
/// This screen demonstrates three critical Flutter development tools:
///
/// 1. HOT RELOAD
///    - Modify this file and save (Ctrl+S)
///    - Press 'r' in terminal or click Hot Reload
///    - See changes instantly without losing app state
///    - Try changing colors, text, or UI properties below
///
/// 2. DEBUG CONSOLE
///    - Watch the terminal for debugPrint() messages
///    - Interact with buttons and watch logs appear
///    - Use debugPrint() for cleaner output than print()
///
/// 3. FLUTTER DEVTOOLS
///    - Open DevTools: flutter pub global run devtools
///    - Use Widget Inspector to inspect this widget tree
///    - Monitor Performance tab while interacting
///    - Check Memory usage in real-time
///
/// QUICK START:
/// 1. Run: flutter run
/// 2. Navigate to this screen from demo buttons
/// 3. Open DevTools: flutter pub global run devtools
/// 4. Make changes below and hot reload to see them instantly
///
/// ============================================================================

class HotReloadDevtoolsDemo extends StatefulWidget {
  const HotReloadDevtoolsDemo({super.key});

  @override
  State<HotReloadDevtoolsDemo> createState() => _HotReloadDevtoolsDemoState();
}

class _HotReloadDevtoolsDemoState extends State<HotReloadDevtoolsDemo> {
  // =========================================================================
  // STATE VARIABLES - Try changing these values and hot reload!
  // =========================================================================
  
  int _tapCount = 0;
  List<String> _actionLog = ['App started...'];
  bool _showDetailedLogs = false;
  Color _primaryColor = Colors.deepPurple;
  Color _accentColor = Colors.cyan;
  double _containerHeight = 150;
  String _appTitle = '🔥 Hot Reload Demo';

  // =========================================================================
  // METHODS WITH DEBUG LOGGING
  // =========================================================================

  void _logAction(String action) {
    debugPrint('[HotReloadDemo] ACTION: $action');
    setState(() {
      _actionLog.add(action);
      if (_actionLog.length > 10) {
        _actionLog.removeAt(0);
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _tapCount++;
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('[DEBUG] Counter incremented to: $_tapCount');
      debugPrint('[DEBUG] Timestamp: ${DateTime.now()}');
      debugPrint('[DEBUG] Widget state: ${runtimeType}');
      debugPrint('═══════════════════════════════════════════════════════════');
    });
    _logAction('Tapped increment button ($_tapCount times)');
  }

  void _resetCounter() {
    setState(() {
      _tapCount = 0;
      debugPrint('[DEBUG] Counter reset to 0');
    });
    _logAction('Counter reset');
  }

  void _toggleDetailedLogs() {
    setState(() {
      _showDetailedLogs = !_showDetailedLogs;
      debugPrint('[DEBUG] Detailed logs toggled: $_showDetailedLogs');
    });
    _logAction('Toggled detailed logs: $_showDetailedLogs');
  }

  void _changeTheme() {
    setState(() {
      debugPrint('[DEBUG] Theme changing...');
      if (_primaryColor == Colors.deepPurple) {
        _primaryColor = Colors.indigo;
        _accentColor = Colors.pink;
        debugPrint('[DEBUG] Theme changed to: Indigo & Pink');
      } else if (_primaryColor == Colors.indigo) {
        _primaryColor = Colors.teal;
        _accentColor = Colors.orange;
        debugPrint('[DEBUG] Theme changed to: Teal & Orange');
      } else {
        _primaryColor = Colors.deepPurple;
        _accentColor = Colors.cyan;
        debugPrint('[DEBUG] Theme changed to: DeepPurple & Cyan (default)');
      }
    });
    _logAction('Theme changed');
  }

  @override
  void initState() {
    super.initState();
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('[LIFECYCLE] initState() called - HotReloadDevtoolsDemo');
    debugPrint('[INFO] Use debugPrint() for clean console output');
    debugPrint('[INFO] Open DevTools to inspect the widget tree');
    debugPrint('════════════════════════════════════════════════════════════');
  }

  @override
  void dispose() {
    debugPrint('[LIFECYCLE] dispose() called - HotReloadDevtoolsDemo');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Log widget build
    debugPrint('[BUILD] HotReloadDevtoolsDemo rebuilding (tap count: $_tapCount)');

    return Scaffold(
      appBar: AppBar(
        title: Text(_appTitle),
        centerTitle: true,
        elevation: 8,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ================================================================
              // SECTION 1: HOT RELOAD DEMONSTRATION
              // ================================================================
              _buildSection(
                title: '⚡ Hot Reload Demo',
                subtitle: 'Modify colors/text below and save (Ctrl+S)',
                color: _primaryColor,
                child: Column(
                  children: [
                    // Try changing these properties and hot reload!
                    Container(
                      height: _containerHeight,
                      width: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _primaryColor,
                            _accentColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '🔄 Hot Reload Works!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try editing the widget\nand pressing r',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _changeTheme,
                          icon: const Icon(Icons.palette),
                          label: const Text('Change Theme'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================================================================
              // SECTION 2: INTERACTIVE COUNTER WITH DEBUG LOGGING
              // ================================================================
              _buildSection(
                title: '🐛 Debug Console Demo',
                subtitle: 'Watch the terminal for debugPrint() messages',
                color: Colors.orange[700]!,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[300]!, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$_tapCount',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap counter',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _incrementCounter,
                          icon: const Icon(Icons.add),
                          label: const Text('Increment'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _resetCounter,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Check the terminal for detailed logs!',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.orange[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================================================================
              // SECTION 3: WIDGET TREE & DEVTOOLS INFO
              // ================================================================
              _buildSection(
                title: '🔍 DevTools & Widget Inspector',
                subtitle: 'Launch DevTools to inspect this widget tree',
                color: Colors.green[700]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[300]!, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            '📱 Widget Type',
                            'StatefulWidget (HotReloadDevtoolsDemo)',
                            Colors.green[700]!,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            '🌳 Widget Tree Depth',
                            'Scaffold → AppBar, Body → Column → Multiple Sections',
                            Colors.green[700]!,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            '⚙️ State Variables',
                            '_tapCount, _actionLog, _primaryColor, etc.',
                            Colors.green[700]!,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _toggleDetailedLogs,
                      icon: Icon(_showDetailedLogs
                          ? Icons.expand_less
                          : Icons.expand_more),
                      label: Text(
                        _showDetailedLogs ? 'Hide Logs' : 'Show Action Logs',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================================================================
              // SECTION 4: ACTION LOG
              // ================================================================
              if (_showDetailedLogs)
                _buildSection(
                  title: '📋 Action Log',
                  subtitle: 'Recent actions logged',
                  color: Colors.blue[700]!,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[300]!, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _actionLog.map((log) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Text(
                                '→',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  log,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[900],
                                    fontFamily: 'Courier',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // ================================================================
              // SECTION 5: INSTRUCTIONS
              // ================================================================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo[300]!, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📚 How to Use These Tools:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionItem(
                      '1. Hot Reload',
                      'Press r in terminal or click Hot Reload\nChange colors/text and save (Ctrl+S)',
                    ),
                    const SizedBox(height: 8),
                    _buildInstructionItem(
                      '2. Debug Console',
                      'Tap buttons above and watch terminal\nLook for [DEBUG] and [LIFECYCLE] logs',
                    ),
                    const SizedBox(height: 8),
                    _buildInstructionItem(
                      '3. Flutter DevTools',
                      'Run: flutter pub global run devtools\nOpen Widget Inspector to inspect tree',
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

  // =========================================================================
  // HELPER WIDGETS
  // =========================================================================

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
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
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionItem(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.indigo[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
