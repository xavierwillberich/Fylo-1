import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/notification.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';
import '../core/widgets/app_error_view.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  
  // Bug 4 修复：获取当前用户 ID
  String? get _currentUserId => AuthService.instance.currentUserId;

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.activityUpdate:
        return LucideIcons.calendar;
      case NotificationType.newFollower:
        return LucideIcons.userPlus;
      case NotificationType.like:
        return LucideIcons.heart;
      case NotificationType.comment:
        return LucideIcons.messageCircle;
      case NotificationType.invitation:
        return LucideIcons.mail;
      case NotificationType.reminder:
        return LucideIcons.bell;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.activityUpdate:
        return const Color(0xFF3B82F6);
      case NotificationType.newFollower:
        return const Color(0xFF10B981);
      case NotificationType.like:
        return const Color(0xFFEF4444);
      case NotificationType.comment:
        return const Color(0xFF8B5CF6);
      case NotificationType.invitation:
        return const Color(0xFF9333EA);
      case NotificationType.reminder:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF9333EA),
                    Color(0xFFEC4899),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Builder(
              builder: (context) {
                // Bug 4 修复：未登录时显示提示
                final userId = _currentUserId;
                if (userId == null) {
                  return const Center(
                    child: Text(
                      '请先登录查看通知',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
                
                return StreamBuilder<List<AppNotification>>(
                  // Bug 4 修复：传入 userId 参数
                  stream: _firebaseService.getNotificationsStream(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      // P1-2: 使用统一错误视图
                      return AppErrorView.fromError(
                        snapshot.error,
                        onRetry: () => setState(() {}),
                      );
                    }

                    final notifications = snapshot.data ?? [];
                  final unreadCount = notifications.where((n) => !n.isRead).length;

                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Unread Notifications',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '$unreadCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    LucideIcons.bell,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (unreadCount > 0)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Mark all as read logic would go here
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(LucideIcons.checkCheck, color: Colors.white, size: 14),
                                          SizedBox(width: 4),
                                          Text(
                                            'Mark all',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: notifications.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFF9333EA).withOpacity(0.2),
                                            const Color(0xFFEC4899).withOpacity(0.2),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        LucideIcons.bell,
                                        size: 40,
                                        color: Color(0xFF9333EA),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No notifications',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'You\'re all caught up!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(20),
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  final notification = notifications[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: notification.isRead ? Colors.white : const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(16),
                                      leading: Stack(
                                        children: [
                                          if (notification.avatar != null)
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: !notification.isRead
                                                      ? const Color(0xFF9333EA)
                                                      : Colors.transparent,
                                                  width: 2,
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius: 24,
                                                backgroundImage: NetworkImage(notification.avatar!),
                                              ),
                                            )
                                          else
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: _getColorForType(notification.type).withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                _getIconForType(notification.type),
                                                color: _getColorForType(notification.type),
                                                size: 24,
                                              ),
                                            ),
                                          if (!notification.isRead)
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFEF4444),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      title: Text(
                                        notification.title,
                                        style: TextStyle(
                                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 6),
                                          Text(
                                            notification.message,
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 14,
                                              height: 1.4,
                                            ),
                                          ),
                                          if (notification.activityId != null) ...[
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF9333EA).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                notification.activityId!,
                                                style: const TextStyle(
                                                  color: Color(0xFF9333EA),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            notification.timestamp.split(' ')[0],
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {},
                                    ),
                                  );
                                },
                                ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}
