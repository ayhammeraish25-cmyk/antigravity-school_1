import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../main.dart'; // To potentially pop or navigate back to home

/// Create Post Screen
/// SOP: Posts can include Text, Images, Infographics, PDF attachments
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _submitPost() async {
    final text = _contentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال محتوى المنشور')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    final success = await _apiService.createPost(text);
    
    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        _contentController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم النشر بنجاح!')),
        );
        // Navigate back to Home
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء منشور'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : ElevatedButton(
                    onPressed: _submitPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0A2342),
                    ),
                    child: const Text('نشر'),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Content text field
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'ماذا تريد أن تشارك؟',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Divider(),
            // Attachment options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachmentOption(Icons.image, 'صورة', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: () {}, // Handled locally placeholder
        ),
        Text(label, style: TextStyle(fontSize: 11, color: color)),
      ],
    );
  }
}

