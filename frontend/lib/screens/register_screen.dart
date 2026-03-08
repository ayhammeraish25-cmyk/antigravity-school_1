import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _dobController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final success = await _apiService.register(
        fullName: _fullNameController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        dob: _dobController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إنشاب الحساب بنجاح. يرجى تسجيل الدخول.')),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Network Error')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل حساب جديد')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'الرجاء إدخال الاسم' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nationalIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'الرقم الوطني',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'الرجاء إدخال الرقم الوطني';
                    if (value.length != 10 || int.tryParse(value) == null) {
                      return 'الرقم الوطني يجب أن يتكون من 10 أرقام';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dobController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'تاريخ الميلاد (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                    hintText: '2000-01-01',
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'الرجاء إدخال تاريخ الميلاد' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المستخدم',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'الرجاء إدخال اسم المستخدم' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'الرجاء إدخال البريد الإلكتروني';
                    if (!value.contains('@')) return 'يرجى إدخال بريد إلكتروني صالح';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'الرجاء إدخال كلمة المرور';
                    if (value.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
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
                      : const Text('إنشاء الحساب', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

