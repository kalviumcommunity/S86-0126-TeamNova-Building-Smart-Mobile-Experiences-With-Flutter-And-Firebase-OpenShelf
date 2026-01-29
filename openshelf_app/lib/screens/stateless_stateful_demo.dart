import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ============================================================================
/// STATELESS vs STATEFUL WIDGETS DEMONSTRATION
/// ============================================================================
///
/// This screen demonstrates the differences between StatelessWidget and
/// StatefulWidget through interactive examples.
///
/// WIDGET HIERARCHY:::
///
/// Scaffold
/// ├─ AppBar
/// └─ Body: SingleChildScrollView
///    └─ Center
///       └─ Column
///          ├─ AppHeader (StatelessWidget) - Static content
///          ├─ SizedBox (spacer)
///          ├─ InteractiveCounter (StatefulWidget) - Dynamic content
///          ├─ SizedBox (spacer)
///          ├─ ThemeChanger (StatefulWidget) - Dynamic content
///          ├─ SizedBox (spacer)
///          └─ VisibilityToggle (StatefulWidget) - Dynamic content
///
/// ============================================================================

class StatelessStatefulDemo extends StatelessWidget {
  const StatelessStatefulDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateless vs Stateful Widgets'),
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
              // SECTION 1: Static Content (StatelessWidget)
              // This never changes unless the parent rebuilds it
              // ============================================================
              AppHeader(),
              
              SizedBox(height: 32),
              
              // ============================================================
              // SECTION 2: Interactive Counter (StatefulWidget)
              // This changes based on user interaction
              // ============================================================
              InteractiveCounter(),
              
              SizedBox(height: 32),
              
              // ============================================================
              // SECTION 3: Theme Changer (StatefulWidget)
              // State changes trigger background color updates
              // ============================================================
              ThemeChanger(),
              
              SizedBox(height: 32),
              
              // ============================================================
              // SECTION 4: Visibility Toggle (StatefulWidget)
              // State controls whether content is visible or hidden
              // ============================================================
              VisibilityToggle(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// COMPONENT 1: APP HEADER (STATELESSWIDGET)
// ============================================================================
/// StatelessWidget Example:
/// - Does not store mutable state
/// - Receives all data through constructor parameters
/// - Immutable and never rebuilds due to internal changes
/// - Perfect for static UI components
///
/// Use Cases:
/// ✓ Headers and titles
/// ✓ Labels and text
/// ✓ Icons and images
/// ✓ Static cards with fixed content

class AppHeader extends StatelessWidget {
  /// Constructor parameters become the "data source"
  /// Any changes must come from parent widget
  final String title = 'Interactive Widget Demo';
  final String subtitle = 'Tap buttons below to see Stateful widgets in action';

  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // This build method doesn't depend on any mutable state
    // If the UI needs to change, the parent must rebuild this widget
    // with different parameters
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[400]!,
              Colors.blue[600]!,
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.widgets,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '📌 This header is a StatelessWidget - it never changes unless the parent widget rebuilds it.',
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
    );
  }
}

// ============================================================================
// COMPONENT 2: INTERACTIVE COUNTER (STATEFULWIDGET)
// ============================================================================
/// StatefulWidget Example:
/// - Maintains internal mutable state
/// - Can change its UI dynamically during app lifecycle
/// - Uses setState() to trigger rebuilds
/// - Perfect for interactive components
///
/// Use Cases:
/// ✓ Counters and forms
/// ✓ Buttons with dynamic labels
/// ✓ Sliders and progress indicators
/// ✓ Tabs and navigation

class InteractiveCounter extends StatefulWidget {
  const InteractiveCounter({super.key});

  @override
  State<InteractiveCounter> createState() => _InteractiveCounterState();
}

class _InteractiveCounterState extends State<InteractiveCounter> {
  // ✅ MUTABLE STATE - This is what makes a StatefulWidget special
  int _count = 0;
  bool _isEven = true;

  // Methods that modify state must call setState()
  // This tells Flutter to rebuild this widget
  void _increment() {
    setState(() {
      _count++;
      _isEven = _count % 2 == 0;
      debugPrint(
        '[InteractiveCounter] Incremented count to $_count | Is even: $_isEven',
      );
      developer.Timeline.finishSync();
    });
  }

  void _decrement() {
    setState(() {
      _count--;
      _isEven = _count % 2 == 0;
      debugPrint(
        '[InteractiveCounter] Decremented count to $_count | Is even: $_isEven',
      );
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
      _isEven = true;
      debugPrint('[InteractiveCounter] Reset counter to 0');
    });
  }

  @override
  Widget build(BuildContext context) {
    // This build() is called every time setState() is invoked
    // Notice how it reflects the current state values
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple[400]!,
              Colors.purple[600]!,
            ],
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Interactive Counter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            
            // Large counter display - CHANGES when state updates
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '$_count',  // ✅ This value changes based on state
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEven ? '✓ Even number' : '✗ Odd number',  // ✅ Changes with state
                    style: TextStyle(
                      fontSize: 14,
                      color: _isEven ? Colors.greenAccent : Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrease'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                  label: const Text('Increase'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple[600],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '🎯 This is a StatefulWidget - it maintains _count state and rebuilds when you tap buttons!',
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
    );
  }
}

// ============================================================================
// COMPONENT 3: THEME CHANGER (STATEFULWIDGET)
// ============================================================================
/// Another StatefulWidget Example:
/// - Shows how state affects styling
/// - Multiple state variables affecting UI
/// - Demonstrates rebuild efficiency

class ThemeChanger extends StatefulWidget {
  const ThemeChanger({super.key});

  @override
  State<ThemeChanger> createState() => _ThemerChangerState();
}

class _ThemerChangerState extends State<ThemeChanger> {
  // ✅ MUTABLE STATE - Color scheme
  bool _isDarkBackground = false;

  void _toggleTheme() {
    setState(() {
      _isDarkBackground = !_isDarkBackground;
      debugPrint(
        '[ThemeChanger] Theme toggled to: ${_isDarkBackground ? 'DARK' : 'LIGHT'}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Colors are calculated based on state
    final bgColor = _isDarkBackground ? Colors.grey[900] : Colors.amber[100];
    final textColor = _isDarkBackground ? Colors.white : Colors.grey[900];
    final buttonColor = _isDarkBackground ? Colors.amber[600] : Colors.amber[400];

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: bgColor,
        ),
        child: Column(
          children: [
            Text(
              'Background Theme',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Display current state
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor == Colors.grey[900]
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _isDarkBackground ? '🌙 Dark Mode' : '☀️ Light Mode',
                style: TextStyle(
                  fontSize: 24,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Toggle button
            ElevatedButton.icon(
              onPressed: _toggleTheme,
              icon: Icon(_isDarkBackground ? Icons.light_mode : Icons.dark_mode),
              label: Text(_isDarkBackground ? 'Switch to Light' : 'Switch to Dark'),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor == Colors.grey[900]
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '💡 When you tap the button, setState() recalculates colors based on the new _isDarkBackground state.',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// COMPONENT 4: VISIBILITY TOGGLE (STATEFULWIDGET)
// ============================================================================
/// Third StatefulWidget Example:
/// - Shows conditional rendering based on state
/// - Multiple child widgets appearing/disappearing

class VisibilityToggle extends StatefulWidget {
  const VisibilityToggle({super.key});

  @override
  State<VisibilityToggle> createState() => _VisibilityToggleState();
}

class _VisibilityToggleState extends State<VisibilityToggle> {
  // ✅ MUTABLE STATE - Visibility control
  bool _isVisible = false;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
      debugPrint(
        '[VisibilityToggle] Content is now: ${_isVisible ? 'VISIBLE' : 'HIDDEN'}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal[400]!,
              Colors.teal[600]!,
            ],
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Conditional Content',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            
            // Toggle button
            ElevatedButton(
              onPressed: _toggleVisibility,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.teal[600],
              ),
              child: Text(_isVisible ? 'Hide Content' : 'Show Content'),
            ),
            const SizedBox(height: 20),
            
            // Conditional content - APPEARS/DISAPPEARS based on state
            if (_isVisible) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  children: [
                    Text(
                      '✨ Hidden Content Revealed! ✨',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'This content only appears when _isVisible is true. '
                      'It is removed from the widget tree when false!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '⚙️ This demonstrates conditional rendering - content appears/disappears based on state!',
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
    );
  }
}
