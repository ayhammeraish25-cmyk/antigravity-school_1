import 'package:flutter/material.dart';

/// Search Screen
/// SOP: Search functionality across educational content
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن محتوى تعليمي...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Category chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildChip('الكل'),
                _buildChip('رياضيات'),
                _buildChip('علوم'),
                _buildChip('لغة عربية'),
                _buildChip('إنجليزي'),
                _buildChip('فيزياء'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Placeholder results
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'ابحث عن الدروس والمنشورات',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: const Color(0xFF0A2342).withAlpha(25),
        labelStyle: const TextStyle(color: Color(0xFF0A2342)),
      ),
    );
  }
}
