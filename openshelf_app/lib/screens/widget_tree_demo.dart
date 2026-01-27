import 'package:flutter/material.dart';

/// ============================================================================
/// WIDGET TREE & REACTIVE UI DEMONSTRATION
/// ============================================================================
///
/// This screen demonstrates Flutter's widget tree concept and reactive UI model.
/// 
/// WIDGET TREE HIERARCHY:
/// Scaffold
/// ├─ AppBar
/// └─ Body: SingleChildScrollView
///    └─ Center
///       └─ Column
///          ├─ ProfileCard (StatefulWidget)
///          │  ├─ Column
///          │  │  ├─ CircleAvatar (Image Container)
///          │  │  ├─ Text (Name)
///          │  │  └─ Text (Status)
///          │  └─ Row (Buttons)
///          │     ├─ ElevatedButton
///          │     ├─ ElevatedButton
///          │     └─ ElevatedButton
///          ├─ SizedBox (Spacer)
///          ├─ InteractiveCounter (StatefulWidget)
///          │  ├─ Card
///          │  │  └─ Column
///          │  │     ├─ Text (Counter)
///          │  │     ├─ SizedBox
///          │  │     └─ Row (Buttons)
///          │  └─ ElevatedButton
///          ├─ SizedBox (Spacer)
///          └─ ThemeToggle (StatefulWidget)
///             └─ Card
///                └─ Column
///                   ├─ Text
///                   └─ Switch
///
/// ============================================================================

class WidgetTreeDemo extends StatelessWidget {
  const WidgetTreeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Tree & Reactive UI Demo'),
        centerTitle: true,
        elevation: 8,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              // ============================================================
              // COMPONENT 1: Profile Card - Demonstrates nested widgets
              //              and state changes affecting UI
              // ============================================================
              ProfileCard(),
              
              SizedBox(height: 32),
              
              // ============================================================
              // COMPONENT 2: Interactive Counter - Shows how setState()
              //              rebuilds only affected widgets
              // ============================================================
              InteractiveCounter(),
              
              SizedBox(height: 32),
              
              // ============================================================
              // COMPONENT 3: Theme Toggle - Demonstrates widget tree 
              //              responding to state changes
              // ============================================================
              ThemeToggle(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// COMPONENT 1: PROFILE CARD
// ============================================================================
/// This is a StatefulWidget that demonstrates:
/// 1. Nested widget hierarchy (Column > Row > Buttons)
/// 2. State changes that trigger UI rebuilds
/// 3. Parent-child relationships

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  // State variables that trigger rebuilds when changed
  String _name = 'Flutter Developer';
  String _status = '🟢 Available';
  int _contactCount = 0;
  bool _isExpanded = false;

  void _updateName() {
    setState(() {
      _name = 'Team Nova Member';
    });
  }

  void _toggleStatus() {
    setState(() {
      _status = _status == '🟢 Available' ? '🔴 Busy' : '🟢 Available';
    });
  }

  void _incrementContacts() {
    setState(() {
      _contactCount++;
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Card is a Material Design container widget
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[300]!,
              Colors.purple[300]!,
            ],
          ),
        ),
        // Main column for card content
        child: Column(
          children: [
            // Avatar - CircleAvatar is a built-in widget for profile images
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            
            // Name text - REBUILDS when _name changes
            Text(
              _name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            
            // Status text - REBUILDS when _status changes
            Text(
              _status,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),
            
            // Contact counter - REBUILDS when _contactCount changes
            Text(
              'Interactions: $_contactCount',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 20),
            
            // Button row - demonstrates horizontal widget arrangement
            if (!_isExpanded)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Update Name Button
                  _buildActionButton(
                    icon: Icons.edit,
                    label: 'Update Name',
                    onPressed: _updateName,
                  ),
                  // Toggle Status Button
                  _buildActionButton(
                    icon: Icons.circle,
                    label: 'Toggle Status',
                    onPressed: _toggleStatus,
                  ),
                  // Contact Button
                  _buildActionButton(
                    icon: Icons.add,
                    label: 'Contact',
                    onPressed: _incrementContacts,
                  ),
                ],
              ),
            
            // Expand/Collapse button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _toggleExpanded,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                ),
                child: Text(_isExpanded ? 'Collapse' : 'Expand'),
              ),
            ),
            
            // Expanded content - shows conditional rendering
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Widget Tree Info',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This card demonstrates:\n'
                      '• Nested widget hierarchy\n'
                      '• State management with setState()\n'
                      '• Conditional rendering with if\n'
                      '• Reactive UI updates',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper widget for action buttons
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ============================================================================
// COMPONENT 2: INTERACTIVE COUNTER
// ============================================================================
/// This demonstrates:
/// 1. How setState() efficiently rebuilds only necessary widgets
/// 2. Counter state and display hierarchy
/// 3. Multiple interactive elements in one widget

class InteractiveCounter extends StatefulWidget {
  const InteractiveCounter({super.key});

  @override
  State<InteractiveCounter> createState() => _InteractiveCounterState();
}

class _InteractiveCounterState extends State<InteractiveCounter> {
  int _counter = 0;
  List<int> _history = [0];
  bool _showHistory = false;

  void _increment() {
    setState(() {
      _counter++;
      _history.add(_counter);
    });
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        _history.add(_counter);
      }
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
      _history = [0];
    });
  }

  void _toggleHistory() {
    setState(() {
      _showHistory = !_showHistory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.orange[300]!,
              Colors.red[300]!,
            ],
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Interactive Counter',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            
            // Large counter display - REBUILDS when _counter changes
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '$_counter',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Updates: ${_history.length - 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Control buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove),
                  label: const Text('Minus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.7),
                    foregroundColor: Colors.red[300],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                  label: const Text('Plus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.7),
                    foregroundColor: Colors.red[300],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.7),
                    foregroundColor: Colors.red[300],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // History toggle button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _toggleHistory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red[300],
                ),
                child: Text(_showHistory ? 'Hide History' : 'Show History'),
              ),
            ),
            
            // History display - REBUILDS when _showHistory changes
            if (_showHistory) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Update History:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _history.map((value) {
                        return Chip(
                          label: Text('$value'),
                          backgroundColor: Colors.white.withOpacity(0.3),
                          labelStyle: const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// COMPONENT 3: THEME TOGGLE
// ============================================================================
/// This demonstrates:
/// 1. How widget properties respond to state changes
/// 2. Dynamic theming and styling
/// 3. Switch widget for boolean state

class ThemeToggle extends StatefulWidget {
  const ThemeToggle({super.key});

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle> {
  bool _isDarkMode = false;
  int _clickCount = 0;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _clickCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Colors change based on _isDarkMode state
    final bgColor = _isDarkMode ? Colors.grey[900]! : Colors.blue[100]!;
    final cardColor = _isDarkMode ? Colors.grey[800]! : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black;
    final accentColor = _isDarkMode ? Colors.cyan : Colors.blue;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: bgColor,
        ),
        child: Column(
          children: [
            Text(
              'Theme Toggle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Display current mode - REBUILDS when _isDarkMode changes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    _isDarkMode ? '🌙 Dark Mode' : '☀️ Light Mode',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Theme changes: $_clickCount',
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Toggle switch - changes state when tapped
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) => _toggleTheme(),
                  activeColor: Colors.cyan,
                  inactiveThumbColor: Colors.blue,
                ),
                const SizedBox(width: 12),
                Text(
                  'Enable Dark Mode',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Explanation box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'When you toggle the switch:\n'
                '• setState() is called\n'
                '• _isDarkMode state changes\n'
                '• Colors are recalculated\n'
                '• Only affected widgets rebuild\n'
                '• The entire widget tree doesn\'t rebuild!',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
