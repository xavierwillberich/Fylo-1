class AppNotification {
  final int id;
  final NotificationType type;
  final String title;
  final String message;
  final String timestamp;
  final String? avatar;
  final String? activityId;
  final bool isRead;

  AppNotification({
    required this.id,
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
      type: NotificationType.values.firstWhere((e) => e.name == json['type']),
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
      avatar: json['avatar'] as String?,
      activityId: json['activityId'] as String?,
      isRead: json['isRead'] as bool,
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
