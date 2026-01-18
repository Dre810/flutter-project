import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';
import '../admin/admin_dashboard.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email input
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            // Password input
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // Login button
            ElevatedButton(
              onPressed: () async {
                var user = await _auth.signInWithEmail(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );

                if (user != null) {
                  // Show SnackBar first
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logged in as ${user.role}')),
                  );

                  // Wait a tiny bit before navigating (Web safe)
                  await Future.delayed(const Duration(milliseconds: 300));

                  if (!mounted) return; // Safety check

                  // Navigate based on role
                  if (user.role == 'admin') {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AdminDashboard()),
                    );
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  }
                } else {
                  setState(() {
                    error = 'Login failed';
                  });
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            // Navigate to registration
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('Don’t have an account? Register'),
            ),
            const SizedBox(height: 10),
            // Error message
            Text(error, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}