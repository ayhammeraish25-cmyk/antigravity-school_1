import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

/// Profile Screen
/// SOP: Displays Name, Role, School, Academic Groups, Uploaded Content
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final profile = await _apiService.getUserProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Network error. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await _apiService.clearToken();
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_userProfile == null) {
      return const Center(child: Text('لا توجد بيانات'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Avatar
          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFF0A2342),
            child: Icon(Icons.person, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            _userProfile!['fullName'] ?? 'اسم الطالب',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0A2342),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _userProfile!['role'] ?? 'طالب',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _userProfile!['school'] ?? 'غير محدد',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat('المنشورات', '${_userProfile!['postsCount'] ?? 0}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0A2342))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

