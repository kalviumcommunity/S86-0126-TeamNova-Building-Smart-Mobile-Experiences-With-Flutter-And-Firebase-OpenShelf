import 'package:flutter/material.dart';
import '../services/cloud_functions_service.dart';

/// Screen to demonstrate Cloud Functions integration
///
/// This screen shows how to:
/// - Call callable functions from Flutter
/// - Display function responses in the UI
/// - Handle loading states and errors
class CloudFunctionsDemo extends StatefulWidget {
  const CloudFunctionsDemo({super.key});

  @override
  State<CloudFunctionsDemo> createState() => _CloudFunctionsDemoState();
}

class _CloudFunctionsDemoState extends State<CloudFunctionsDemo> {
  final CloudFunctionsService _functionsService = CloudFunctionsService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();

  String _helloMessage = '';
  String _bookResult = '';
  bool _isLoadingHello = false;
  bool _isLoadingBook = false;

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  /// Call the sayHello cloud function
  Future<void> _callSayHello() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a name')));
      return;
    }

    setState(() {
      _isLoadingHello = true;
      _helloMessage = '';
    });

    try {
      final result = await _functionsService.sayHello(
        _nameController.text.trim(),
      );

      setState(() {
        _helloMessage = result['message'] ?? 'No message received';
        _isLoadingHello = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Function executed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      setState(() {
        _helloMessage = 'Error: $error';
        _isLoadingHello = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $error'), backgroundColor: Colors.red),
      );
    }
  }

  /// Call the addBookRecommendation cloud function
  Future<void> _callAddBookRecommendation() async {
    if (_titleController.text.trim().isEmpty ||
        _authorController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter title and author')),
      );
      return;
    }

    setState(() {
      _isLoadingBook = true;
      _bookResult = '';
    });

    try {
      final result = await _functionsService.addBookRecommendation(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        genre: _genreController.text.trim().isEmpty
            ? null
            : _genreController.text.trim(),
      );

      setState(() {
        _bookResult =
            'Book added with ID: ${result['bookId']}\n${result['message']}';
        _isLoadingBook = false;
      });

      // Clear form
      _titleController.clear();
      _authorController.clear();
      _genreController.clear();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Book recommendation added!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      setState(() {
        _bookResult = 'Error: $error';
        _isLoadingBook = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $error'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Functions Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cloud, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Cloud Functions Demo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Test callable functions and see serverless backend in action!',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Say Hello Function Section
            _buildSectionHeader('1. Say Hello Function'),
            const SizedBox(height: 8),
            const Text(
              'Call a simple cloud function that returns a personalized greeting.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _isLoadingHello ? null : _callSayHello,
              icon: _isLoadingHello
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(
                _isLoadingHello ? 'Calling Function...' : 'Call sayHello()',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),

            if (_helloMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                color: _helloMessage.startsWith('Error')
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _helloMessage.startsWith('Error')
                                ? Icons.error
                                : Icons.check_circle,
                            color: _helloMessage.startsWith('Error')
                                ? Colors.red
                                : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Response:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_helloMessage),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),

            // Add Book Recommendation Function Section
            _buildSectionHeader('2. Add Book Recommendation'),
            const SizedBox(height: 8),
            const Text(
              'Add a book recommendation with validation and auto-metadata.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Book Title *',
                hintText: 'e.g., Clean Code',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Author *',
                hintText: 'e.g., Robert C. Martin',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _genreController,
              decoration: const InputDecoration(
                labelText: 'Genre (Optional)',
                hintText: 'e.g., Programming',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _isLoadingBook ? null : _callAddBookRecommendation,
              icon: _isLoadingBook
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add),
              label: Text(
                _isLoadingBook ? 'Adding Book...' : 'Add Recommendation',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),

            if (_bookResult.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                color: _bookResult.startsWith('Error')
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _bookResult.startsWith('Error')
                                ? Icons.error
                                : Icons.check_circle,
                            color: _bookResult.startsWith('Error')
                                ? Colors.red
                                : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Result:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_bookResult),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Instructions Card
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'View Logs',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Go to Firebase Console → Functions → Logs\n'
                      '• Execute functions above\n'
                      '• Check logs for execution details\n'
                      '• Take screenshots for documentation',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
