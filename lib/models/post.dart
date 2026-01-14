import 'package:cloud_firestore/cloud_firestore.dart';

/// Post 模型
/// Bug 2 修复：添加顶层 userId 字段以符合 Firestore rules 要求
/// 优化：支持 Firestore Timestamp，同时保持向后兼容
class Post {
  final int id;
  final String userId; // Bug 2 修复：顶层 userId 字段（与 Firebase Auth uid 对应）
  final PostUser user;
  final PostContent content;
  final DateTime? createdAt; // 优化：使用 DateTime 存储创建时间
  final String timestamp; // 保留用于 UI 显示的格式化时间
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isFollowing;
  final RelatedActivity? relatedActivity;

  Post({
    required this.id,
    required this.userId,
    required this.user,
    required this.content,
    this.createdAt,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isLiked,
    required this.isFollowing,
    this.relatedActivity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'user': user.toJson(),
      'content': content.toJson(),
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'timestamp': timestamp, // 保留用于显示
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'isLiked': isLiked,
      'isFollowing': isFollowing,
      'relatedActivity': relatedActivity?.toJson(),
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    // 兼容旧数据：处理可能缺失的字段
    // 解析 createdAt（支持 Timestamp / String / null）
    DateTime? createdAt;
    final createdAtRaw = json['createdAt'];
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is String && createdAtRaw.isNotEmpty) {
      createdAt = DateTime.tryParse(createdAtRaw);
    }
    
    // 解析 timestamp 用于显示（兼容 Timestamp / String）
    String displayTimestamp = '';
    final timestampRaw = json['timestamp'];
    if (timestampRaw is Timestamp) {
      displayTimestamp = _formatTimestamp(timestampRaw.toDate());
    } else if (timestampRaw is String) {
      displayTimestamp = timestampRaw;
    } else if (createdAt != null) {
      displayTimestamp = _formatTimestamp(createdAt);
    }
    
    return Post(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: json['userId'] as String? ?? '',
      user: json['user'] != null
          ? PostUser.fromJson(json['user'] as Map<String, dynamic>)
          : PostUser(name: 'Unknown', username: '', avatar: ''),
      content: json['content'] != null
          ? PostContent.fromJson(json['content'] as Map<String, dynamic>)
          : PostContent(text: '', images: []),
      createdAt: createdAt,
      timestamp: displayTimestamp,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isFollowing: json['isFollowing'] as bool? ?? false,
      relatedActivity: json['relatedActivity'] != null
          ? RelatedActivity.fromJson(json['relatedActivity'] as Map<String, dynamic>)
          : null,
    );
  }
  
  /// 格式化时间戳为可读字符串
  static String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }

  /// copyWith 方法：用于在 UI 层覆盖 isLiked/isFollowing 状态
  Post copyWith({
    int? id,
    String? userId,
    PostUser? user,
    PostContent? content,
    DateTime? createdAt,
    String? timestamp,
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
    bool? isFollowing,
    RelatedActivity? relatedActivity,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
      relatedActivity: relatedActivity ?? this.relatedActivity,
    );
  }
}

class PostUser {
  final String name;
  final String username;
  final String avatar;

  PostUser({
    required this.name,
    required this.username,
    required this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'avatar': avatar,
    };
  }

  factory PostUser.fromJson(Map<String, dynamic> json) {
    return PostUser(
      name: json['name'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String,
    );
  }
}

class PostContent {
  final String text;
  final List<String> images;

  PostContent({
    required this.text,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'images': images,
    };
  }

  factory PostContent.fromJson(Map<String, dynamic> json) {
    return PostContent(
      text: json['text'] as String,
      images: List<String>.from(json['images'] as List),
    );
  }
}

class RelatedActivity {
  final String activityId;
  final String title;
  final String image;

  RelatedActivity({
    required this.activityId,
    required this.title,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'activityId': activityId,
      'title': title,
      'image': image,
    };
  }

  factory RelatedActivity.fromJson(Map<String, dynamic> json) {
    return RelatedActivity(
      activityId: json['activityId'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
    );
  }
}
