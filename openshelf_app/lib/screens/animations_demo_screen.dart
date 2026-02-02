import 'package:flutter/material.dart';
import 'dart:math' as math;

/// AnimationsDemoScreen demonstrates Flutter's animation capabilities.
///
/// This screen showcases:
/// - Implicit animations (AnimatedContainer, AnimatedOpacity, AnimatedAlign)
/// - Explicit animations (AnimationController with RotationTransition, ScaleTransition)
/// - Tween animations for custom values
/// - Curve variations for different motion feels
/// - Interactive animation controls
///
/// Learning Objectives:
/// 1. Understand implicit vs explicit animations
/// 2. Use AnimationController for precise control
/// 3. Apply curves for natural motion
/// 4. Create engaging, meaningful animations
/// 5. Optimize animation performance
class AnimationsDemoScreen extends StatefulWidget {
  const AnimationsDemoScreen({super.key});

  @override
  State<AnimationsDemoScreen> createState() => _AnimationsDemoScreenState();
}

class _AnimationsDemoScreenState extends State<AnimationsDemoScreen>
    with TickerProviderStateMixin {
  // Implicit animation states
  bool _containerToggled = false;
  bool _opacityToggled = true;
  bool _alignToggled = false;
  bool _paddingToggled = false;

  // Explicit animation controllers
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _bounceController;
  late AnimationController _pulseController;

  // Custom animations
  late Animation<double> _bounceAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Rotation animation (continuous loop)
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Scale animation (bounce back and forth)
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Bounce animation with custom curve
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0, end: -100).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.bounceOut,
      ),
    );

    // Pulse animation with color change
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(_pulseController);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _bounceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _playBounceAnimation() {
    _bounceController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animations & Transitions'),
        centerTitle: true,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Introduction Card
          _buildIntroCard(),
          const SizedBox(height: 24),

          // Section 1: Implicit Animations
          _buildSectionTitle('🎯 Implicit Animations', Icons.auto_awesome),
          const SizedBox(height: 12),
          _buildAnimatedContainerDemo(),
          const SizedBox(height: 16),
          _buildAnimatedOpacityDemo(),
          const SizedBox(height: 16),
          _buildAnimatedAlignDemo(),
          const SizedBox(height: 16),
          _buildAnimatedPaddingDemo(),
          const SizedBox(height: 24),

          // Section 2: Explicit Animations
          _buildSectionTitle('⚙️ Explicit Animations', Icons.settings_suggest),
          const SizedBox(height: 12),
          _buildRotationDemo(),
          const SizedBox(height: 16),
          _buildScaleDemo(),
          const SizedBox(height: 16),
          _buildBounceDemo(),
          const SizedBox(height: 16),
          _buildColorPulseDemo(),
          const SizedBox(height: 24),

          // Section 3: Animation Curves
          _buildSectionTitle('📈 Animation Curves', Icons.show_chart),
          const SizedBox(height: 12),
          _buildCurvesDemo(),
          const SizedBox(height: 24),

          // Section 4: Best Practices
          _buildSectionTitle('✨ Best Practices', Icons.tips_and_updates),
          const SizedBox(height: 12),
          _buildBestPracticesCard(),
          const SizedBox(height: 24),

          // Navigation to Page Transitions Demo
          _buildNavigationCard(),
        ],
      ),
    );
  }

  /// Introduction card
  Widget _buildIntroCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.animation, color: Colors.blue[700], size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Animations & Transitions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Animations bring your app to life by making UI elements respond '
              'fluidly to user actions. This demo showcases both implicit and explicit '
              'animations for creating polished, professional user experiences.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Key Concepts:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text('• Implicit animations: AnimatedContainer, AnimatedOpacity',
                      style: TextStyle(fontSize: 13)),
                  Text('• Explicit animations: AnimationController, Tween',
                      style: TextStyle(fontSize: 13)),
                  Text('• Curves: easeInOut, bounceOut, elasticInOut',
                      style: TextStyle(fontSize: 13)),
                  Text('• Page transitions: SlideTransition, FadeTransition',
                      style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section title widget
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  /// AnimatedContainer demo
  Widget _buildAnimatedContainerDemo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AnimatedContainer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Automatically animates changes to width, height, color, padding, etc.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _containerToggled = !_containerToggled;
                  });
                },
                child: AnimatedContainer(
                  width: _containerToggled ? 200 : 100,
                  height: _containerToggled ? 100 : 200,
                  decoration: BoxDecoration(
                    color: _containerToggled ? Colors.teal : Colors.orange,
                    borderRadius: BorderRadius.circular(_containerToggled ? 50 : 10),
                    boxShadow: [
                      BoxShadow(
                        color: (_containerToggled ? Colors.teal : Colors.orange)
                            .withOpacity(0.5),
                        blurRadius: _containerToggled ? 20 : 10,
                        spreadRadius: _containerToggled ? 5 : 2,
                      ),
                    ],
                  ),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  child: const Center(
                    child: Text(
                      'Tap Me!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '''AnimatedContainer(
  width: toggled ? 200 : 100,
  height: toggled ? 100 : 200,
  color: toggled ? Colors.teal : Colors.orange,
  duration: Duration(seconds: 1),
  curve: Curves.easeInOut,
)''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// AnimatedOpacity demo
  Widget _buildAnimatedOpacityDemo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AnimatedOpacity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Creates smooth fade-in and fade-out effects.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  AnimatedOpacity(
                    opacity: _opacityToggled ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple[400]!, Colors.pink[400]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.star,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _opacityToggled = !_opacityToggled;
                      });
                    },
                    icon: Icon(_opacityToggled ? Icons.visibility_off : Icons.visibility),
                    label: Text(_opacityToggled ? 'Fade Out' : 'Fade In'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '''AnimatedOpacity(
  opacity: toggled ? 1.0 : 0.0,
  duration: Duration(milliseconds: 800),
  curve: Curves.easeInOut,
  child: /* Your widget */,
)''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// AnimatedAlign demo
  Widget _buildAnimatedAlignDemo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AnimatedAlign',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Smoothly moves widgets to different positions.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: AnimatedAlign(
                alignment: _alignToggled ? Alignment.topRight : Alignment.bottomLeft,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.cyan],
                    ),
                  ),
                  child: const Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _alignToggled = !_alignToggled;
                  });
                },
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Move Position'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// AnimatedPadding demo
  Widget _buildAnimatedPaddingDemo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AnimatedPadding',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Animates padding changes smoothly.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedPadding(
                padding: EdgeInsets.all(_paddingToggled ? 40 : 8),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber[600],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Padded Box',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _paddingToggled = !_paddingToggled;
                  });
                },
                icon: Icon(_paddingToggled ? Icons.compress : Icons.expand),
                label: Text(_paddingToggled ? 'Decrease Padding' : 'Increase Padding'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Rotation animation demo (explicit)
  Widget _buildRotationDemo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RotationTransition (Explicit)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Uses AnimationController for precise rotation control.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Center(
              child: RotationTransition(
                turns: _rotationController,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red[400]!, Colors.orange[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.refresh,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '''AnimationController(
  duration: Duration(seconds: 3),
  vsync: this,
)..repeat();

RotationTransition(
  turns: controller,
  child: /* Your widget */,
)''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Scale animation demo
  Widget _buildScaleDemo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ScaleTransition',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Animates the size/scale of a widget.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.2).animate(
                  CurvedAnimation(
                    parent: _scaleController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.teal],
                    ),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '''ScaleTransition(
  scale: Tween<double>(begin: 0.8, end: 1.2).animate(
    CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ),
  ),
  child: /* Your widget */,
)''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bounce animation demo
  Widget _buildBounceDemo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bounce Animation',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Custom animation with Curves.bounceOut for playful effect.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                height: 150,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _bounceAnimation.value),
                          child: child,
                        );
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.indigo, Colors.purple],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: const Icon(
                          Icons.sports_basketball,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _playBounceAnimation,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Bounce!'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Color pulse demo
  Widget _buildColorPulseDemo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Color Pulse Animation',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Animated color transitions using ColorTween.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Center(
              child: AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _colorAnimation.value,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _colorAnimation.value!.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lightbulb,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Animation curves demo
  Widget _buildCurvesDemo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Common Animation Curves',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Curves define the speed and feel of animations:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            _buildCurveItem('Curves.linear', 'Constant speed throughout', Colors.grey),
            const SizedBox(height: 8),
            _buildCurveItem('Curves.easeIn', 'Slow start, fast end', Colors.blue),
            const SizedBox(height: 8),
            _buildCurveItem('Curves.easeOut', 'Fast start, slow end', Colors.green),
            const SizedBox(height: 8),
            _buildCurveItem('Curves.easeInOut', 'Slow start and end (recommended)', Colors.orange),
            const SizedBox(height: 8),
            _buildCurveItem('Curves.bounceOut', 'Bouncy, playful effect', Colors.purple),
            const SizedBox(height: 8),
            _buildCurveItem('Curves.elasticInOut', 'Spring-like motion', Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildCurveItem(String name, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Best practices card
  Widget _buildBestPracticesCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Animation Best Practices',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildBestPracticeItem(
              Icons.timer,
              'Duration',
              'Keep animations between 200-800ms for responsiveness',
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildBestPracticeItem(
              Icons.show_chart,
              'Curves',
              'Use easeInOut or fastOutSlowIn for natural motion',
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildBestPracticeItem(
              Icons.visibility,
              'Purpose',
              'Animate with purpose - guide attention, provide feedback',
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildBestPracticeItem(
              Icons.speed,
              'Performance',
              'Test on real devices, avoid excessive animations',
              Colors.red,
            ),
            const SizedBox(height: 12),
            _buildBestPracticeItem(
              Icons.done,
              'Subtlety',
              'Smooth, subtle transitions feel more professional',
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestPracticeItem(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Navigation card to page transitions demo
  Widget _buildNavigationCard() {
    return Card(
      elevation: 3,
      color: Colors.deepPurple[50],
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/page-transitions');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.swap_horiz,
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
                      'Page Transitions Demo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Explore slide, fade, scale, and custom page transitions',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.deepPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
