import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// AssetDemoScreen demonstrates how to use images, icons, and local assets in Flutter.
///
/// This screen showcases:
/// - Loading and displaying local images using Image.asset()
/// - Using Flutter's built-in Material and Cupertino icons
/// - Combining images and icons in UI layouts
/// - Proper asset management and error handling
/// - Background images using DecorationImage
///
/// Learning Objectives:
/// 1. Understand asset registration in pubspec.yaml
/// 2. Display local images with different fit modes
/// 3. Use Material and Cupertino icon libraries
/// 4. Handle missing assets gracefully
/// 5. Create visually appealing layouts with mixed media
class AssetDemoScreen extends StatelessWidget {
  const AssetDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets Demo'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: Introduction Card
            _buildIntroCard(),
            const SizedBox(height: 24),

            // Section 2: Image Asset Examples
            _buildSectionTitle('📸 Image Assets', Icons.image),
            const SizedBox(height: 12),
            _buildImageExamples(),
            const SizedBox(height: 24),

            // Section 3: Icon Examples
            _buildSectionTitle('⭐ Built-in Icons', Icons.star),
            const SizedBox(height: 12),
            _buildIconExamples(),
            const SizedBox(height: 24),

            // Section 4: Combined Layout
            _buildSectionTitle('🎨 Combined Layout', Icons.palette),
            const SizedBox(height: 12),
            _buildCombinedExample(),
            const SizedBox(height: 24),

            // Section 5: Background Image Example
            _buildSectionTitle('🖼️ Background Images', Icons.wallpaper),
            const SizedBox(height: 12),
            _buildBackgroundExample(),
            const SizedBox(height: 24),

            // Section 6: Icon Variations
            _buildSectionTitle('🔧 Icon Variations', Icons.construction),
            const SizedBox(height: 12),
            _buildIconVariations(),
            const SizedBox(height: 24),

            // Section 7: Platform-Specific Icons
            _buildSectionTitle('📱 Platform Icons', Icons.devices),
            const SizedBox(height: 12),
            _buildPlatformIcons(),
          ],
        ),
      ),
    );
  }

  /// Introduction card explaining asset management
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
                Icon(Icons.info_outline, color: Colors.blue[700], size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Managing Assets in Flutter',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'This screen demonstrates how to load and display local images, '
              'use Flutter\'s built-in icons, and properly manage assets in your project.',
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
                  Text(
                    '• Image.asset() for local images',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '• Icon() for Material icons',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '• CupertinoIcons for iOS-style icons',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '• AssetImage for decoration backgrounds',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '• pubspec.yaml asset registration',
                    style: TextStyle(fontSize: 13),
                  ),
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

  /// Image asset examples with different fit modes
  Widget _buildImageExamples() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Local Image Examples',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Example 1: Logo with placeholder
            _buildImageCard(
              'App Logo',
              'assets/images/logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              showCode: true,
              codeSnippet: '''Image.asset(
  'assets/images/logo.png',
  width: 120,
  height: 120,
  fit: BoxFit.contain,
)''',
            ),
            const SizedBox(height: 16),

            // Example 2: Banner
            _buildImageCard(
              'Banner Image',
              'assets/images/banner.jpg',
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
              showCode: true,
              codeSnippet: '''Image.asset(
  'assets/images/banner.jpg',
  width: double.infinity,
  height: 150,
  fit: BoxFit.cover,
)''',
            ),
            const SizedBox(height: 12),

            // Instruction for adding images
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.amber[800]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Add your images to assets/images/ folder to see them here!',
                      style: TextStyle(fontSize: 13),
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

  /// Helper to build image card with error handling
  Widget _buildImageCard(
    String label,
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    bool showCode = false,
    String? codeSnippet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              assetPath,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Image not found',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add $assetPath',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        if (showCode && codeSnippet != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              codeSnippet,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Colors.greenAccent,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Built-in Material icons examples
  Widget _buildIconExamples() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Material Icons Library',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Flutter provides 1000+ built-in Material icons that work out of the box:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Icon grid
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildIconItem(Icons.home, 'Home', Colors.blue),
                _buildIconItem(Icons.favorite, 'Favorite', Colors.red),
                _buildIconItem(Icons.star, 'Star', Colors.amber),
                _buildIconItem(Icons.person, 'Person', Colors.green),
                _buildIconItem(Icons.settings, 'Settings', Colors.grey),
                _buildIconItem(Icons.search, 'Search', Colors.purple),
                _buildIconItem(
                  Icons.notifications,
                  'Notifications',
                  Colors.orange,
                ),
                _buildIconItem(Icons.shopping_cart, 'Cart', Colors.teal),
                _buildIconItem(Icons.email, 'Email', Colors.indigo),
                _buildIconItem(Icons.phone, 'Phone', Colors.cyan),
                _buildIconItem(Icons.camera, 'Camera', Colors.pink),
                _buildIconItem(Icons.location_on, 'Location', Colors.redAccent),
              ],
            ),
            const SizedBox(height: 16),

            // Code example
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '''Icon(
  Icons.star,
  color: Colors.amber,
  size: 32,
)''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Individual icon item
  Widget _buildIconItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  /// Combined image and icon layout example
  Widget _buildCombinedExample() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Combining Images & Icons',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Profile card example
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[100]!, Colors.blue[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Profile image with placeholder
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icons/profile.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'OpenShelf User',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Flutter Developer',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),

                  // Icon row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem(Icons.book, '24', 'Books'),
                      const SizedBox(width: 24),
                      _buildStatItem(Icons.favorite, '12', 'Favorites'),
                      const SizedBox(width: 24),
                      _buildStatItem(Icons.share, '8', 'Shared'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Stat item for combined example
  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.deepPurple),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  /// Background image example
  Widget _buildBackgroundExample() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Background Images with DecorationImage',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                  onError: null,
                ),
                color: Colors.deepPurple[50], // Fallback color
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flutter_dash, size: 48, color: Colors.white),
                      SizedBox(height: 12),
                      Text(
                        'Welcome to OpenShelf!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Powered by Flutter',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Code example
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '''Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/background.png'),
      fit: BoxFit.cover,
    ),
  ),
  child: /* Your content */,
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

  /// Icon variations (outlined, filled, rounded, sharp)
  Widget _buildIconVariations() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Icon Style Variations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Material icons come in different styles:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconStyleItem(Icons.favorite, 'Filled', Colors.red),
                _buildIconStyleItem(
                  Icons.favorite_border,
                  'Outlined',
                  Colors.red,
                ),
                _buildIconStyleItem(
                  Icons.favorite_rounded,
                  'Rounded',
                  Colors.red,
                ),
                _buildIconStyleItem(Icons.favorite_sharp, 'Sharp', Colors.red),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconStyleItem(Icons.star, 'Filled', Colors.amber),
                _buildIconStyleItem(
                  Icons.star_border,
                  'Outlined',
                  Colors.amber,
                ),
                _buildIconStyleItem(
                  Icons.star_rounded,
                  'Rounded',
                  Colors.amber,
                ),
                _buildIconStyleItem(Icons.star_sharp, 'Sharp', Colors.amber),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Icon style item
  Widget _buildIconStyleItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 36, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  /// Platform-specific icons (Material vs Cupertino)
  Widget _buildPlatformIcons() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Platform-Specific Icons',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Material (Android) vs Cupertino (iOS) icon styles:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Material (Android)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.home, color: Colors.green[700]),
                                Icon(Icons.search, color: Colors.green[700]),
                                Icon(Icons.person, color: Colors.green[700]),
                                Icon(Icons.settings, color: Colors.green[700]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Cupertino (iOS)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  CupertinoIcons.home,
                                  color: Colors.blue[700],
                                ),
                                Icon(
                                  CupertinoIcons.search,
                                  color: Colors.blue[700],
                                ),
                                Icon(
                                  CupertinoIcons.person,
                                  color: Colors.blue[700],
                                ),
                                Icon(
                                  CupertinoIcons.settings,
                                  color: Colors.blue[700],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Code examples
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '// Material Icons',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Icon(Icons.home)',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.greenAccent,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '// Cupertino Icons',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "import 'package:flutter/cupertino.dart';",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Text(
                    'Icon(CupertinoIcons.home)',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.greenAccent,
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
}
