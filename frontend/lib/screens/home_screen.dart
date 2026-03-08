import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/post_model.dart';
import '../widgets/post_card.dart';

/// Home Screen - Educational Feed
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<PostModel> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final posts = await _apiService.getPosts();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Network error. Please try again.';
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_error!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سراج', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPosts,
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchPosts,
              child: const Text('إعادة المحاولة'),
            )
          ],
        ),
      );
    }

    if (_posts.isEmpty) {
      return const Center(child: Text('No posts yet', style: TextStyle(fontSize: 18, color: Colors.grey)));
    }

    return RefreshIndicator(
      onRefresh: _fetchPosts,
      child: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: _posts[index]);
        },
      ),
    );
  }
}
