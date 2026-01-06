class Post {
  final int id;
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
}

class PostContent {
  final String text;
  final List<String> images;

  PostContent({
    required this.text,
    required this.images,
  });
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
}
