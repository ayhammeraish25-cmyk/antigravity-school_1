class PostModel {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String authorRole;
  final String school;
  final String type;
  final String timeAgo;
  final int likes;
  final int comments;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorRole,
    required this.school,
    required this.type,
    required this.timeAgo,
    required this.likes,
    required this.comments,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      authorName: json['author']?['fullName'] ?? 'مستخدم غير معروف',
      authorRole: json['author']?['role'] ?? 'طالب',
      school: json['author']?['school'] ?? 'غير محدد',
      type: json['type'] ?? 'TEXT',
      timeAgo: _calculateTimeAgo(json['createdAt']),
      likes: json['likesCount'] ?? 0,
      comments: json['commentsCount'] ?? 0,
    );
  }

  static String _calculateTimeAgo(String? dateStr) {
    if (dateStr == null) return 'غير معروف';
    final date = DateTime.tryParse(dateStr);
    if (date == null) return 'غير معروف';
    
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} أيام';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعات';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقائق';
    } else {
      return 'الآن';
    }
  }
}
