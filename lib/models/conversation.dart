enum ConversationType {
  direct,
  group,
  activity,
}

class Conversation {
  final String id;
  final ConversationType type;
  final String name;
  final String? avatar;
  final List<String> participantIds;
  final Map<String, String> participantNames;
  final Map<String, String> participantAvatars;
  final String? lastMessageContent;
  final String? lastMessageSenderId;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? activityId;
  final bool isActive;
  final Map<String, bool> mutedBy;

  Conversation({
    required this.id,
    required this.type,
    required this.name,
    this.avatar,
    required this.participantIds,
    required this.participantNames,
    required this.participantAvatars,
    this.lastMessageContent,
    this.lastMessageSenderId,
    this.lastMessageTime,
    this.unreadCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.activityId,
    this.isActive = true,
    this.mutedBy = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'avatar': avatar,
      'participantIds': participantIds,
      'participantNames': participantNames,
      'participantAvatars': participantAvatars,
      'lastMessageContent': lastMessageContent,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'unreadCount': unreadCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'activityId': activityId,
      'isActive': isActive,
      'mutedBy': mutedBy,
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      type: ConversationType.values.firstWhere((e) => e.name == json['type']),
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      participantIds: List<String>.from(json['participantIds'] as List),
      participantNames: Map<String, String>.from(json['participantNames'] as Map),
      participantAvatars: Map<String, String>.from(json['participantAvatars'] as Map),
      lastMessageContent: json['lastMessageContent'] as String?,
      lastMessageSenderId: json['lastMessageSenderId'] as String?,
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'] as String)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      activityId: json['activityId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      mutedBy: json['mutedBy'] != null
          ? Map<String, bool>.from(json['mutedBy'] as Map)
          : {},
    );
  }

  Conversation copyWith({
    String? lastMessageContent,
    String? lastMessageSenderId,
    DateTime? lastMessageTime,
    int? unreadCount,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id,
      type: type,
      name: name,
      avatar: avatar,
      participantIds: participantIds,
      participantNames: participantNames,
      participantAvatars: participantAvatars,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      activityId: activityId,
      isActive: isActive,
      mutedBy: mutedBy,
    );
  }
}
