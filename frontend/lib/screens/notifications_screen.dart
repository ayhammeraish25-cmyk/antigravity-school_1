import 'package:flutter/material.dart';

/// Notifications Screen
/// SOP: Notifications for content updates, assignments, and academic events
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
      ),
      body: ListView(
        children: [
          _buildNotificationItem(
            icon: Icons.assignment,
            color: Colors.blue,
            title: 'واجب جديد',
            subtitle: 'أ. محمد الأحمد أضاف واجب رياضيات - الموعد النهائي: غداً',
            time: 'منذ 30 دقيقة',
            isUnread: true,
          ),
          _buildNotificationItem(
            icon: Icons.favorite,
            color: Colors.red,
            title: 'إعجاب',
            subtitle: 'سارة خالد أعجبت بمنشورك',
            time: 'منذ ساعة',
            isUnread: true,
          ),
          _buildNotificationItem(
            icon: Icons.quiz,
            color: Colors.orange,
            title: 'اختبار جديد',
            subtitle: 'أ. ليلى عبدالله أنشأت اختبار فيزياء',
            time: 'منذ 3 ساعات',
            isUnread: false,
          ),
          _buildNotificationItem(
            icon: Icons.comment,
            color: Colors.green,
            title: 'تعليق',
            subtitle: 'أحمد علق على منشورك: "ممتاز!"',
            time: 'أمس',
            isUnread: false,
          ),
          _buildNotificationItem(
            icon: Icons.grade,
            color: Colors.purple,
            title: 'درجة جديدة',
            subtitle: 'حصلت على 95/100 في واجب العلوم',
            time: 'أمس',
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      color: isUnread ? const Color(0xFF0A2342).withAlpha(13) : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(51),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ),
    );
  }
}
