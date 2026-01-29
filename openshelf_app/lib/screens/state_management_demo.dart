import 'package:flutter/material.dart';

/// ============================================================================
/// STATE MANAGEMENT DEMO - USING setState() AND STATEFUL LOGIC
/// ============================================================================
///
/// This screen demonstrates comprehensive state management in Flutter:
/// 1. StatefulWidget vs StatelessWidget concepts
/// 2. Using setState() for reactive UI updates
/// 3. Managing multiple state variables
/// 4. Conditional rendering based on state
/// 5. Performance considerations with state updates
///
/// Learning Objectives:
/// - Understand when to use StatefulWidget vs StatelessWidget
/// - Master setState() for local state management
/// - Learn about widget lifecycle methods
/// - Implement reactive UI patterns
/// - Avoid common state management pitfalls
///
/// ============================================================================

class StateManagementDemo extends StatefulWidget {
  const StateManagementDemo({super.key});

  @override
  State<StateManagementDemo> createState() => _StateManagementDemoState();
}

class _StateManagementDemoState extends State<StateManagementDemo>
    with SingleTickerProviderStateMixin {
  // ============================================================================
  // STATE VARIABLES
  // ============================================================================

  // Counter state
  int _counter = 0;
  int _totalTaps = 0;

  // Toggle states
  bool _isLiked = false;
  bool _isBookmarked = false;
  bool _isDarkMode = false;

  // Slider state
  double _sliderValue = 50.0;

  // Text input state
  String _currentText = '';
  final TextEditingController _textController = TextEditingController();

  // Animation state
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    debugPrint('🟢 StateManagementDemo: initState() called');
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    debugPrint('🔴 StateManagementDemo: dispose() called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 StateManagementDemo: build() called');

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'State Management Demo',
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: _isDarkMode ? Colors.grey[850] : Colors.deepPurple,
        elevation: 2,
        actions: [
          // Dark mode toggle
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: _isDarkMode ? Colors.yellow : Colors.white,
            ),
            onPressed: _toggleDarkMode,
            tooltip: 'Toggle Dark Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              const SizedBox(height: 24),

              // Counter Section
              _buildCounterSection(),
              const SizedBox(height: 24),

              // Toggle Buttons Section
              _buildToggleSection(),
              const SizedBox(height: 24),

              // Slider Section
              _buildSliderSection(),
              const SizedBox(height: 24),

              // Text Input Section
              _buildTextInputSection(),
              const SizedBox(height: 24),

              // Stats Section
              _buildStatsSection(),
              const SizedBox(height: 24),

              // Info Box
              _buildInfoBox(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // UI COMPONENTS
  // ============================================================================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isDarkMode
              ? [Colors.grey[800]!, Colors.grey[700]!]
              : [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.settings_suggest,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'State Management',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Master setState() and reactive UI',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterSection() {
    // Conditional color based on counter value
    Color counterColor = _getCounterColor();
    String counterMessage = _getCounterMessage();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: counterColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Counter Demo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          // Counter Display with Animation
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: counterColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: counterColor, width: 3),
              ),
              child: Column(
                children: [
                  Text(
                    '$_counter',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: counterColor,
                    ),
                  ),
                  Text(
                    counterMessage,
                    style: TextStyle(
                      fontSize: 12,
                      color: counterColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Counter Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _decrementCounter,
                icon: const Icon(Icons.remove),
                label: const Text('Decrement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _resetCounter,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _incrementCounter,
                icon: const Icon(Icons.add),
                label: const Text('Increment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Toggle States',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          // Like Button
          _buildToggleButton(
            isActive: _isLiked,
            activeIcon: Icons.favorite,
            inactiveIcon: Icons.favorite_border,
            activeColor: Colors.red,
            inactiveColor: Colors.grey,
            label: _isLiked ? 'Liked' : 'Like',
            onTap: _toggleLike,
          ),
          const SizedBox(height: 12),
          
          // Bookmark Button
          _buildToggleButton(
            isActive: _isBookmarked,
            activeIcon: Icons.bookmark,
            inactiveIcon: Icons.bookmark_border,
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            label: _isBookmarked ? 'Bookmarked' : 'Bookmark',
            onTap: _toggleBookmark,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required bool isActive,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required Color activeColor,
    required Color inactiveColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withOpacity(0.1)
              : (_isDarkMode ? Colors.grey[700] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? activeColor : inactiveColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? activeColor : inactiveColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? activeColor
                      : (_isDarkMode ? Colors.white70 : Colors.black87),
                ),
              ),
            ),
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Slider Value',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_sliderValue.toInt()}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.deepPurple,
              inactiveTrackColor: Colors.deepPurple.withOpacity(0.2),
              thumbColor: Colors.deepPurple,
              overlayColor: Colors.deepPurple.withOpacity(0.2),
              trackHeight: 6,
            ),
            child: Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: _updateSliderValue,
            ),
          ),
          
          // Progress bar visualization
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _sliderValue / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(_sliderValue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Text Input',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Type something...',
              prefixIcon: const Icon(Icons.edit, color: Colors.deepPurple),
              suffixIcon: _currentText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: _clearText,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: _isDarkMode ? Colors.grey[700] : Colors.grey[50],
            ),
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
            onChanged: _updateText,
          ),
          const SizedBox(height: 16),
          
          if (_currentText.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Live Preview:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentText,
                    style: TextStyle(
                      fontSize: 16,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Characters: ${_currentText.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Session Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Taps',
                  '$_totalTaps',
                  Icons.touch_app,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Counter',
                  '$_counter',
                  Icons.numbers,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Liked',
                  _isLiked ? 'Yes' : 'No',
                  Icons.favorite,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Saved',
                  _isBookmarked ? 'Yes' : 'No',
                  Icons.bookmark,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
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
            style: TextStyle(
              fontSize: 12,
              color: _isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDarkMode
            ? Colors.blue[900]!.withOpacity(0.3)
            : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDarkMode ? Colors.blue[700]! : Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.blue[700], size: 20),
              const SizedBox(width: 12),
              Text(
                'setState() Concepts',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.blue[300] : Colors.blue[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '✓ StatefulWidget holds mutable state\n'
            '✓ setState() triggers UI rebuilds\n'
            '✓ Only changed widgets are rebuilt\n'
            '✓ State persists across rebuilds\n'
            '✓ Lifecycle: initState → build → dispose',
            style: TextStyle(
              fontSize: 12,
              color: _isDarkMode ? Colors.blue[200] : Colors.blue[800],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // STATE UPDATE METHODS
  // ============================================================================

  void _incrementCounter() {
    setState(() {
      _counter++;
      _totalTaps++;
    });
    _animationController.forward().then((_) => _animationController.reverse());
    debugPrint('✅ Counter incremented to: $_counter');
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
      _totalTaps++;
    });
    _animationController.forward().then((_) => _animationController.reverse());
    debugPrint('➖ Counter decremented to: $_counter');
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _totalTaps++;
    });
    _animationController.forward().then((_) => _animationController.reverse());
    debugPrint('🔄 Counter reset to 0');
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _totalTaps++;
    });
    debugPrint('❤️ Like toggled: $_isLiked');
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
      _totalTaps++;
    });
    debugPrint('🔖 Bookmark toggled: $_isBookmarked');
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    debugPrint('🌙 Dark mode toggled: $_isDarkMode');
  }

  void _updateSliderValue(double value) {
    setState(() {
      _sliderValue = value;
    });
    debugPrint('📊 Slider value updated: ${value.toInt()}%');
  }

  void _updateText(String text) {
    setState(() {
      _currentText = text;
    });
    debugPrint('📝 Text updated: $text');
  }

  void _clearText() {
    setState(() {
      _currentText = '';
      _textController.clear();
    });
    debugPrint('🗑️ Text cleared');
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  Color _getCounterColor() {
    if (_counter == 0) return Colors.grey;
    if (_counter < 5) return Colors.blue;
    if (_counter < 10) return Colors.green;
    if (_counter < 15) return Colors.orange;
    return Colors.red;
  }

  String _getCounterMessage() {
    if (_counter == 0) return 'Start counting!';
    if (_counter < 5) return 'Getting started';
    if (_counter < 10) return 'Nice progress!';
    if (_counter < 15) return 'Keep going!';
    return 'Excellent!';
  }

  Color _getProgressColor(double value) {
    if (value < 25) return Colors.red;
    if (value < 50) return Colors.orange;
    if (value < 75) return Colors.blue;
    return Colors.green;
  }
}
