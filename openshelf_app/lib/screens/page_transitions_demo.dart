import 'package:flutter/material.dart';

/// PageTransitionsDemo showcases different page transition animations.
///
/// This screen demonstrates:
/// - SlideTransition (slide from different directions)
/// - FadeTransition (fade in/out)
/// - ScaleTransition (zoom in/out)
/// - RotationTransition (rotate while transitioning)
/// - Custom combined transitions
///
/// Learning Objectives:
/// 1. Use PageRouteBuilder for custom transitions
/// 2. Combine multiple transitions for unique effects
/// 3. Control transition duration and curves
/// 4. Create smooth, professional page navigation
class PageTransitionsDemo extends StatelessWidget {
  const PageTransitionsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Transitions'),
        centerTitle: true,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Introduction
          _buildIntroCard(),
          const SizedBox(height: 24),

          // Transition type cards
          _buildTransitionCard(
            context,
            'Slide Transition (Right)',
            'Page slides in from the right (default iOS style)',
            Icons.arrow_forward,
            Colors.blue,
            () => _navigateWithSlideTransition(context, SlideDirection.fromRight),
          ),
          const SizedBox(height: 12),
          _buildTransitionCard(
            context,
            'Slide Transition (Left)',
            'Page slides in from the left (Android back style)',
            Icons.arrow_back,
            Colors.blue,
            () => _navigateWithSlideTransition(context, SlideDirection.fromLeft),
          ),
          const SizedBox(height: 12),
          _buildTransitionCard(
            context,
            'Slide Transition (Up)',
            'Page slides in from the bottom (modal style)',
            Icons.arrow_upward,
            Colors.blue,
            () => _navigateWithSlideTransition(context, SlideDirection.fromBottom),
          ),
          const SizedBox(height: 12),
          _buildTransitionCard(
            context,
            'Fade Transition',
            'Page fades in smoothly (elegant effect)',
            Icons.blur_on,
            Colors.green,
            () => _navigateWithFadeTransition(context),
          ),
          const SizedBox(height: 12),
          _buildTransitionCard(
            context,
            'Scale Transition',
            'Page zooms in from center (modern feel)',
            Icons.zoom_in,
            Colors.orange,
            () => _navigateWithScaleTransition(context),
          ),
          const SizedBox(height: 12),
          _buildTransitionCard(
            context,
            'Rotation Transition',
            'Page rotates while appearing (playful)',
            Icons.rotate_right,
            Colors.purple,
            () => _navigateWithRotationTransition(context),
          ),
          const SizedBox(height: 12),
          _buildTransitionCard(
            context,
            'Fade + Scale Combined',
            'Page fades and scales simultaneously (polished)',
            Icons.auto_awesome,
            Colors.pink,
            () => _navigateWithCombinedTransition(context),
          ),
          const SizedBox(height: 12),
          _buildTransitionCard(
            context,
            'Slide + Fade Combined',
            'Page slides and fades together (smooth blend)',
            Icons.animation,
            Colors.teal,
            () => _navigateWithSlideFadeTransition(context),
          ),
        ],
      ),
    );
  }

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
                Icon(Icons.swap_horiz, color: Colors.deepPurple[700], size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Page Transition Animations',
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
              'Page transitions make navigation feel smooth and intentional. '
              'Tap any card below to see different transition styles in action.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.deepPurple[200]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.deepPurple, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Each transition uses PageRouteBuilder for custom control',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitionCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
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
              Icon(Icons.arrow_forward_ios, color: color.withOpacity(0.5), size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // Slide Transition
  void _navigateWithSlideTransition(BuildContext context, SlideDirection direction) {
    Offset begin;
    switch (direction) {
      case SlideDirection.fromRight:
        begin = const Offset(1.0, 0.0);
        break;
      case SlideDirection.fromLeft:
        begin = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.fromBottom:
        begin = const Offset(0.0, 1.0);
        break;
      case SlideDirection.fromTop:
        begin = const Offset(0.0, -1.0);
        break;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            _SampleDestinationPage(transitionType: 'Slide (${direction.name})'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: begin,
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    );
  }

  // Fade Transition
  void _navigateWithFadeTransition(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _SampleDestinationPage(transitionType: 'Fade'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }

  // Scale Transition
  void _navigateWithScaleTransition(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _SampleDestinationPage(transitionType: 'Scale'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }

  // Rotation Transition
  void _navigateWithRotationTransition(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _SampleDestinationPage(transitionType: 'Rotation'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return RotationTransition(
            turns: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }

  // Combined: Fade + Scale
  void _navigateWithCombinedTransition(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _SampleDestinationPage(transitionType: 'Fade + Scale'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  // Combined: Slide + Fade
  void _navigateWithSlideFadeTransition(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _SampleDestinationPage(transitionType: 'Slide + Fade'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.3, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

enum SlideDirection { fromRight, fromLeft, fromBottom, fromTop }

/// Sample destination page to demonstrate transitions
class _SampleDestinationPage extends StatelessWidget {
  final String transitionType;

  const _SampleDestinationPage({required this.transitionType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$transitionType Transition'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple[100]!,
              Colors.blue[100]!,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 80,
                        color: Colors.green[400],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Success!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'You navigated with',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          transitionType,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Notice how the page transitioned smoothly?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
