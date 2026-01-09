enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  location,
  activity,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final MessageType type;
  final String content;
  final List<String>? mediaUrls;
  final String? activityId;
  final DateTime timestamp;
  final MessageStatus status;
  final List<String> readBy;
  final String? replyToMessageId;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.type,
    required this.content,
    this.mediaUrls,
    this.activityId,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.readBy = const [],
    this.replyToMessageId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'type': type.name,
      'content': content,
      'mediaUrls': mediaUrls,
      'activityId': activityId,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
      'readBy': readBy,
      'replyToMessageId': replyToMessageId,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String,
      type: MessageType.values.firstWhere((e) => e.name == json['type']),
      content: json['content'] as String,
      mediaUrls: json['mediaUrls'] != null 
          ? List<String>.from(json['mediaUrls'] as List)
          : null,
      activityId: json['activityId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      readBy: json['readBy'] != null 
          ? List<String>.from(json['readBy'] as List)
          : [],
      replyToMessageId: json['replyToMessageId'] as String?,
    );
  }

  ChatMessage copyWith({
    MessageStatus? status,
    List<String>? readBy,
  }) {
    return ChatMessage(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      type: type,
      content: content,
      mediaUrls: mediaUrls,
      activityId: activityId,
      timestamp: timestamp,
      status: status ?? this.status,
      readBy: readBy ?? this.readBy,
      replyToMessageId: replyToMessageId,
    );
  }
}
