/// Post 模型
/// Bug 2 修复：添加顶层 userId 字段以符合 Firestore rules 要求
class Post {
  final int id;
  final String userId; // Bug 2 修复：顶层 userId 字段（与 Firebase Auth uid 对应）
  final PostUser user;
  final PostContent content;
  final String timestamp;
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
      'userId': userId, // Bug 2 修复：序列化 userId
      'user': user.toJson(),
      'content': content.toJson(),
      'timestamp': timestamp,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'isLiked': isLiked,
      'isFollowing': isFollowing,
      'relatedActivity': relatedActivity?.toJson(),
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userId: json['userId'] as String? ?? '', // Bug 2 修复：反序列化 userId，兼容旧数据
      user: PostUser.fromJson(json['user'] as Map<String, dynamic>),
      content: PostContent.fromJson(json['content'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      shares: json['shares'] as int,
      isLiked: json['isLiked'] as bool,
      isFollowing: json['isFollowing'] as bool,
      relatedActivity: json['relatedActivity'] != null
          ? RelatedActivity.fromJson(json['relatedActivity'] as Map<String, dynamic>)
          : null,
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
