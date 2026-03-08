import 'package:flutter/material.dart';
import '../models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author header
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF0A2342),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${post.authorRole} • ${post.school}\n${post.timeAgo}', style: const TextStyle(fontSize: 12)),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(post.content, style: const TextStyle(fontSize: 15)),
          ),
          if (post.type == 'IMAGE')
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A2342).withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 48, color: Color(0xFF0A2342)),
              ),
            ),
          // Actions 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border, size: 20),
                  label: Text('${post.likes}'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.comment_outlined, size: 20),
                  label: Text('${post.comments}'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined, size: 20),
                  label: const Text('مشاركة'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
