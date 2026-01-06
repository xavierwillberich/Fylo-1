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
}

enum NotificationType {
  activityUpdate,
  newFollower,
  like,
  comment,
  invitation,
  reminder,
}
