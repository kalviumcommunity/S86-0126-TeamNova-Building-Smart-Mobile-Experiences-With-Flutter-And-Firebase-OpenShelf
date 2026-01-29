import 'package:flutter/material.dart';

/// ============================================================================
/// USER INPUT FORM - HANDLING TEXT INPUT, VALIDATION, AND FORM STATE
/// ============================================================================
///
/// This screen demonstrates comprehensive user input handling in Flutter:
/// 1. TextField and TextFormField widgets
/// 2. Form validation with GlobalKey<FormState>
/// 3. TextEditingController for input management
/// 4. Input decoration and styling
/// 5. Error handling and user feedback.
/// 6. SnackBar notifications
///
/// Learning Objectives:
/// - Master TextField and TextFormField usage
/// - Implement form validation logic
/// - Manage form state with controllers
/// - Provide user feedback with SnackBar
/// - Handle different input types (text, email, password, etc.)
///
/// ============================================================================

class UserInputForm extends StatefulWidget {
  const UserInputForm({super.key});

  @override
  State<UserInputForm> createState() => _UserInputFormState();
}

class _UserInputFormState extends State<UserInputForm> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _messageController = TextEditingController();

  // State variables
  bool _obscurePassword = true;
  bool _acceptTerms = false;
  String _selectedCategory = 'Feedback';

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Input Form'),
        backgroundColor: Colors.deepPurple,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              const SizedBox(height: 24),

              // Form Section
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    _buildNameField(),
                    const SizedBox(height: 16),

                    // Email Field
                    _buildEmailField(),
                    const SizedBox(height: 16),

                    // Password Field
                    _buildPasswordField(),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    _buildCategoryDropdown(),
                    const SizedBox(height: 16),

                    // Message Field
                    _buildMessageField(),
                    const SizedBox(height: 16),

                    // Terms and Conditions Checkbox
                    _buildTermsCheckbox(),
                    const SizedBox(height: 24),

                    // Submit and Clear Buttons
                    _buildActionButtons(),
                    const SizedBox(height: 24),

                    // Info Box
                    _buildInfoBox(),
                  ],
                ),
              ),
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
          colors: [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
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
                  Icons.edit_document,
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
                      'User Input Form',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Learn form handling and validation',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
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

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: const Icon(Icons.person, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        if (value.length < 3) {
          return 'Name must be at least 3 characters';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'example@email.com',
        prefixIcon: const Icon(Icons.email, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        // Email regex pattern
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email address';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter a strong password',
        prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: const Icon(Icons.category, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: ['Feedback', 'Support', 'Suggestion', 'Bug Report', 'Other']
          .map(
            (category) =>
                DropdownMenuItem(value: category, child: Text(category)),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value!;
        });
      },
    );
  }

  Widget _buildMessageField() {
    return TextFormField(
      controller: _messageController,
      decoration: InputDecoration(
        labelText: 'Message',
        hintText: 'Enter your message here...',
        prefixIcon: const Icon(Icons.message, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a message';
        }
        if (value.length < 10) {
          return 'Message must be at least 10 characters';
        }
        return null;
      },
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value!;
            });
          },
          activeColor: Colors.deepPurple,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: const Text(
              'I accept the terms and conditions',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send),
                SizedBox(width: 8),
                Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: _clearForm,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Colors.deepPurple, width: 2),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.clear),
                SizedBox(width: 8),
                Text(
                  'Clear',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.blue[700], size: 20),
              const SizedBox(width: 12),
              Text(
                'Form Validation Tips',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '✓ Name must be at least 3 characters\n'
            '✓ Email must be in valid format (example@email.com)\n'
            '✓ Password must be at least 6 characters\n'
            '✓ Message must be at least 10 characters\n'
            '✓ Accept terms and conditions to submit',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[800],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // FORM ACTIONS
  // ============================================================================

  void _submitForm() {
    // Validate form
    if (_formKey.currentState!.validate()) {
      // Check terms acceptance
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Please accept the terms and conditions')),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Form Submitted Successfully!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Welcome, ${_nameController.text}!',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );

      // Print form data to console (for debugging)
      debugPrint('=== FORM SUBMITTED ===');
      debugPrint('Name: ${_nameController.text}');
      debugPrint('Email: ${_emailController.text}');
      debugPrint('Category: $_selectedCategory');
      debugPrint('Message: ${_messageController.text}');
      debugPrint('======================');
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Please fix the errors in the form')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _clearForm() {
    // Clear all text fields
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _messageController.clear();

    // Reset state
    setState(() {
      _acceptTerms = false;
      _selectedCategory = 'Feedback';
    });

    // Reset form validation
    _formKey.currentState?.reset();

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.refresh, color: Colors.white),
            SizedBox(width: 12),
            Text('Form cleared successfully'),
          ],
        ),
        backgroundColor: Colors.grey[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
