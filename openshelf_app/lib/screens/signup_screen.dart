import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = await authService.signUp(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
                if (user != null) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
