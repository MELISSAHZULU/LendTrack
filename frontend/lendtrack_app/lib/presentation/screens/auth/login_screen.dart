import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/data/services/api_service.dart';
import 'package:lendtrack_app/presentation/screens/dashboard/dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'admin@lendtrack.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  bool _isLoading = false;
  final ApiService _api = ApiService();

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _api.login(email, password);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: [
            const SizedBox(height: 20),
            const Text('LendTrack', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 6),
            const Text('Welcome back', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            const Text('Sign in to your LendTrack account', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 28),
            
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined, size: 20),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 4),
            
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 30)),
                child: const Text('Forgot Password?', style: TextStyle(fontSize: 13)),
              ),
            ),
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Sign In', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 14),
            
            const Row(
              children: [
                Expanded(child: Divider(thickness: 0.5)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('or', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                Expanded(child: Divider(thickness: 0.5)),
              ],
            ),
            const SizedBox(height: 14),
            
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.fingerprint, size: 20),
                label: const Text('Sign in with Biometrics', style: TextStyle(fontSize: 14)),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ),
            const SizedBox(height: 14),
            
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Demo Credentials:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text('Email: admin@lendtrack.com', style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                  Text('Password: any password', style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                  const SizedBox(height: 4),
                  Text('⚠️ Backend must be running at localhost:8000', style: TextStyle(fontSize: 10, color: Colors.orange.shade700)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
