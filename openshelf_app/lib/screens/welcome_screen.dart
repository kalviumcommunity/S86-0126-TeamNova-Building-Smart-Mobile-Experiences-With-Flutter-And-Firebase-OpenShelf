import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isGreeting = false;
  Color _buttonColor = Colors.blue;

  void _toggleGreeting() {
    setState(() {
      _isGreeting = !_isGreeting;
      _buttonColor = _isGreeting ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenShelf'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            // Title
            Text(
              _isGreeting ? 'Welcome to OpenShelf!' : 'Hello There!',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Icon/Image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple.withValues(alpha: 0.1),
              ),
              child: Icon(
                _isGreeting ? Icons.library_books : Icons.book,
                size: 60,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 30),

            // Description text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                _isGreeting
                    ? 'Explore a world of shared knowledge and resources!'
                    : 'Your gateway to innovative solutions',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),

            // Button
            ElevatedButton(
              onPressed: _toggleGreeting,
              style: ElevatedButton.styleFrom(
                backgroundColor: _buttonColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                _isGreeting ? 'Explore Now' : 'Get Started',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Responsive Layout Button
            SizedBox(
              width: 280,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/responsive-layout');
                },
                icon: const Icon(Icons.dashboard, size: 22),
                label: const Text(
                  'Responsive Layout Dashboard',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  shadowColor: Colors.indigo.withOpacity(0.4),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Multi-Screen Navigation Demo Button
            SizedBox(
              width: 280,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/navigation-hub');
                },
                icon: const Icon(Icons.navigation, size: 22),
                label: const Text(
                  'Multi-Screen Navigation Demo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[500],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  shadowColor: Colors.red.withOpacity(0.4),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Scrollable Views Button
            SizedBox(
              width: 280,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/scrollable-views');
                },
                icon: const Icon(Icons.list, size: 22),
                label: const Text(
                  'Scrollable Views - ListView & GridView',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  shadowColor: Colors.teal.withOpacity(0.4),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Navigate to Responsive Home
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/responsive');
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View Responsive UI'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
