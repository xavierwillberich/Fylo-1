/// AppNotification 模型
/// Bug 3 修复：添加 receiverId 字段以符合 Firestore rules 要求
class AppNotification {
  final int id;
  final String receiverId; // Bug 3 修复：通知接收者 ID（与 Firebase Auth uid 对应）
  final NotificationType type;
  final String title;
  final String message;
  final String timestamp;
  final String? avatar;
  final String? activityId;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.receiverId,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.avatar,
    this.activityId,
    required this.isRead,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiverId': receiverId, // Bug 3 修复：序列化 receiverId
      'type': type.name,
      'title': title,
      'message': message,
      'timestamp': timestamp,
      'avatar': avatar,
      'activityId': activityId,
      'isRead': isRead,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as int,
      receiverId: json['receiverId'] as String? ?? '', // Bug 3 修复：反序列化 receiverId，兼容旧数据
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.activityUpdate,
      ),
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
      avatar: json['avatar'] as String?,
      activityId: json['activityId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}

enum NotificationType {
  activityUpdate,
  newFollower,
  like,
  comment,
  invitation,
  reminder,
}
