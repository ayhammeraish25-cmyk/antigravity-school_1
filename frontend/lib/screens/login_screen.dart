import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'register_screen.dart';
import '../main.dart'; // To access MainNavigation

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nationalIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _login() async {
    final nationalId = _nationalIdController.text.trim();
    final password = _passwordController.text;

    if (nationalId.length != 10 || int.tryParse(nationalId) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرقم الوطني يجب أن يتكون من 10 أرقام')),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال كلمة المرور')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    final success = await _apiService.login(nationalId, password);
    
    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect National ID or Password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.school, size: 80, color: Color(0xFF0A2342)),
              const SizedBox(height: 24),
              const Text(
                'منصة سراج التعليمية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A2342),
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _nationalIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'الرقم الوطني (National ID)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A2342),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading 
                    ? const SizedBox(
                        height: 24, 
                        width: 24, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text('تسجيل الدخول', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => const RegisterScreen())
                  );
                },
                child: const Text('ليس لديك حساب؟ سجل الآن'),
              )
            ],
          ),
        ),
      ),
    );
  }
}