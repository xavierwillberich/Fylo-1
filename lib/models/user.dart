class User {
  final String id;
  final String name;
  final String username;
  final String avatar;
  final String? bio;
  final String? location;
  final bool isOnline;
  final DateTime? lastSeen;
  final List<String> interests;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.avatar,
    this.bio,
    this.location,
    this.isOnline = false,
    this.lastSeen,
    this.interests = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatar': avatar,
      'bio': bio,
      'location': location,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
      'interests': interests,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: json['lastSeen'] != null 
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
      interests: json['interests'] != null 
          ? List<String>.from(json['interests'] as List)
          : [],
    );
  }
}
