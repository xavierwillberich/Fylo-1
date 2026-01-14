import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';
import '../models/post.dart';
import '../models/notification.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../models/conversation.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEvent(Event event) async {
    await _firestore.collection('events').doc(event.id.toString()).set(event.toJson());
  }

  Future<void> updateEvent(Event event) async {
    await _firestore.collection('events').doc(event.id.toString()).update(event.toJson());
  }

  Future<void> deleteEvent(int eventId) async {
    await _firestore.collection('events').doc(eventId.toString()).delete();
  }

  Future<Event?> getEvent(int eventId) async {
    final doc = await _firestore.collection('events').doc(eventId.toString()).get();
    if (doc.exists && doc.data() != null) {
      return Event.fromJson(doc.data()!);
    }
    return null;
  }

  Stream<List<Event>> getEventsStream() {
    return _firestore.collection('events').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList();
    });
  }

  Future<List<Event>> getAllEvents() async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList();
  }

  Stream<List<Event>> getUserEventsStream(String userId) {
    return _firestore.collection('events').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Event.fromJson(doc.data()))
          .where((event) => event.creatorId == userId || event.participantIds.contains(userId))
          .toList();
    });
  }

  Future<List<Event>> getUserEvents(String userId) async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs
        .map((doc) => Event.fromJson(doc.data()))
        .where((event) => event.creatorId == userId || event.participantIds.contains(userId))
        .toList();
  }

  Future<void> addPost(Post post) async {
    await _firestore.collection('posts').doc(post.id.toString()).set(post.toJson());
  }

  Future<void> updatePost(Post post) async {
    await _firestore.collection('posts').doc(post.id.toString()).update(post.toJson());
  }

  Future<void> deletePost(int postId) async {
    await _firestore.collection('posts').doc(postId.toString()).delete();
  }

  Future<Post?> getPost(int postId) async {
    final doc = await _firestore.collection('posts').doc(postId.toString()).get();
    if (doc.exists && doc.data() != null) {
      return Post.fromJson(doc.data()!);
    }
    return null;
  }

  Stream<List<Post>> getPostsStream() {
    return _firestore.collection('posts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();
    });
  }

  Future<List<Post>> getAllPosts() async {
    final snapshot = await _firestore.collection('posts').get();
    return snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();
  }

  Future<void> addNotification(AppNotification notification) async {
    await _firestore.collection('notifications').doc(notification.id.toString()).set(notification.toJson());
  }

  Future<void> updateNotification(AppNotification notification) async {
    await _firestore.collection('notifications').doc(notification.id.toString()).update(notification.toJson());
  }

  Future<void> deleteNotification(int notificationId) async {
    await _firestore.collection('notifications').doc(notificationId.toString()).delete();
  }

  Future<AppNotification?> getNotification(int notificationId) async {
    final doc = await _firestore.collection('notifications').doc(notificationId.toString()).get();
    if (doc.exists && doc.data() != null) {
      return AppNotification.fromJson(doc.data()!);
    }
    return null;
  }

  /// Bug 4 修复：按 receiverId 过滤通知，符合 Firestore rules 要求
  /// 现在需要传入 userId 参数
  Stream<List<AppNotification>> getNotificationsStream(String userId) {
    return _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = int.tryParse(doc.id) ?? 0;
            return AppNotification.fromJson(data);
          }).toList();
        });
  }

  /// Bug 4 修复：按 receiverId 过滤通知
  Future<List<AppNotification>> getNotificationsForUser(String userId) async {
    final snapshot = await _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = int.tryParse(doc.id) ?? 0;
      return AppNotification.fromJson(data);
    }).toList();
  }

  @Deprecated('Use getNotificationsForUser(userId) instead - this will fail with current Firestore rules')
  Future<List<AppNotification>> getAllNotifications() async {
    final snapshot = await _firestore.collection('notifications').get();
    return snapshot.docs.map((doc) => AppNotification.fromJson(doc.data())).toList();
  }

  Future<void> uploadSampleData() async {
    final batch = _firestore.batch();
    
    final events = [
      Event(
        id: 1,
        date: '28',
        month: 'Oct',
        year: '2025',
        dayOfWeek: 'Tuesday',
        weather: Weather.clear,
        temperature: 68,
        category: 'Trips',
        title: 'Weekend Hiking Adventure - Mount Rainier Trail',
        description: 'Join us for a scenic 8-mile hike through alpine meadows and old-growth forests. Perfect for nature lovers and photography enthusiasts. All skill levels welcome!',
        time: '7:00 AM',
        location: 'Mount Rainier National Park, WA',
        participants: 12,
        budget: 45,
        recruiting: true,
        proficiency: ProficiencyLevel.intermediate,
        genderRestriction: GenderRestriction.noRestrictions,
        passwordRequired: false,
        images: [
          'https://images.unsplash.com/photo-1623622863859-2931a6c3bc80?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080',
          'https://images.unsplash.com/photo-1723470317938-6ec6fb0d4075?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080',
        ],
        attendeeAvatars: [
          'https://images.unsplash.com/photo-1581065178047-8ee15951ede6?w=100',
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        ],
        isUserParticipating: false,
      ),
    ];

    for (var event in events) {
      batch.set(_firestore.collection('events').doc(event.id.toString()), event.toJson());
    }

    await batch.commit();
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    await _firestore.collection('notifications').doc(notificationId.toString()).update({
      'isRead': true,
    });
  }

  Future<void> toggleEventParticipation(int eventId, bool isParticipating) async {
    await _firestore.collection('events').doc(eventId.toString()).update({
      'isUserParticipating': isParticipating,
    });
  }

  Future<void> togglePostLike(int postId, bool isLiked, int newLikeCount) async {
    await _firestore.collection('posts').doc(postId.toString()).update({
      'isLiked': isLiked,
      'likes': newLikeCount,
    });
  }

  Future<void> toggleFollowUser(int postId, bool isFollowing) async {
    await _firestore.collection('posts').doc(postId.toString()).update({
      'isFollowing': isFollowing,
    });
  }

  Future<void> addUser(User user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson());
  }

  Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.id).update(user.toJson());
  }

  Future<User?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists && doc.data() != null) {
      return User.fromJson(doc.data()!);
    }
    return null;
  }

  Future<List<User>> searchUsers(String query) async {
    final snapshot = await _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
    return snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
  }

  /// P0-5 修复：更新用户在线状态
  /// 使用 FieldValue.serverTimestamp() 确保时间一致性
  Future<void> updateUserOnlineStatus(String userId, bool isOnline) async {
    await _firestore.collection('users').doc(userId).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  Future<String> createConversation(Conversation conversation) async {
    final docRef = await _firestore.collection('conversations').add(conversation.toJson());
    return docRef.id;
  }

  Future<String> createDirectConversation(String userId1, String userId2) async {
    final existingConversations = await _firestore
        .collection('conversations')
        .where('type', isEqualTo: 'direct')
        .where('participantIds', arrayContains: userId1)
        .get();

    for (var doc in existingConversations.docs) {
      final conversation = Conversation.fromJson(doc.data());
      if (conversation.participantIds.contains(userId2)) {
        return doc.id;
      }
    }

    final user1 = await getUser(userId1);
    final user2 = await getUser(userId2);

    if (user1 == null || user2 == null) {
      throw Exception('Users not found');
    }

    final conversation = Conversation(
      id: '',
      type: ConversationType.direct,
      name: user2.name,
      avatar: user2.avatar,
      participantIds: [userId1, userId2],
      participantNames: {
        userId1: user1.name,
        userId2: user2.name,
      },
      participantAvatars: {
        userId1: user1.avatar,
        userId2: user2.avatar,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await createConversation(conversation);
  }

  Future<String> createGroupConversation({
    required String name,
    required List<String> participantIds,
    String? avatar,
    String? activityId,
  }) async {
    final participantNames = <String, String>{};
    final participantAvatars = <String, String>{};

    for (var userId in participantIds) {
      final user = await getUser(userId);
      if (user != null) {
        participantNames[userId] = user.name;
        participantAvatars[userId] = user.avatar;
      }
    }

    final conversation = Conversation(
      id: '',
      type: activityId != null ? ConversationType.activity : ConversationType.group,
      name: name,
      avatar: avatar,
      participantIds: participantIds,
      participantNames: participantNames,
      participantAvatars: participantAvatars,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      activityId: activityId,
    );

    return await createConversation(conversation);
  }

  Future<void> updateConversation(String conversationId, Conversation conversation) async {
    await _firestore.collection('conversations').doc(conversationId).update(conversation.toJson());
  }

  Future<Conversation?> getConversation(String conversationId) async {
    final doc = await _firestore.collection('conversations').doc(conversationId).get();
    if (doc.exists && doc.data() != null) {
      return Conversation.fromJson(doc.data()!);
    }
    return null;
  }

  Stream<List<Conversation>> getUserConversationsStream(String userId) {
    return _firestore
        .collection('conversations')
        .where('participantIds', arrayContains: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Conversation.fromJson(data);
      }).toList();
    });
  }

  Future<List<Conversation>> getUserConversations(String userId) async {
    final snapshot = await _firestore
        .collection('conversations')
        .where('participantIds', arrayContains: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Conversation.fromJson(data);
    }).toList();
  }

  Future<void> addParticipantToConversation(String conversationId, String userId) async {
    final user = await getUser(userId);
    if (user == null) return;

    await _firestore.collection('conversations').doc(conversationId).update({
      'participantIds': FieldValue.arrayUnion([userId]),
      'participantNames.$userId': user.name,
      'participantAvatars.$userId': user.avatar,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeParticipantFromConversation(String conversationId, String userId) async {
    await _firestore.collection('conversations').doc(conversationId).update({
      'participantIds': FieldValue.arrayRemove([userId]),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<String> sendMessage(ChatMessage message) async {
    final docRef = await _firestore
        .collection('conversations')
        .doc(message.conversationId)
        .collection('messages')
        .add(message.toJson());

    await _firestore.collection('conversations').doc(message.conversationId).update({
      'lastMessageContent': message.content,
      'lastMessageSenderId': message.senderId,
      'lastMessageTime': message.timestamp.toIso8601String(),
      'updatedAt': message.timestamp.toIso8601String(),
    });

    return docRef.id;
  }

  Future<void> updateMessage(String conversationId, ChatMessage message) async {
    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(message.id)
        .update(message.toJson());
  }

  Future<void> deleteMessage(String conversationId, String messageId) async {
    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  Stream<List<ChatMessage>> getMessagesStream(String conversationId, {int limit = 50}) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ChatMessage.fromJson(data);
      }).toList();
    });
  }

  Future<List<ChatMessage>> getMessages(String conversationId, {int limit = 50}) async {
    final snapshot = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return ChatMessage.fromJson(data);
    }).toList();
  }

  Future<List<ChatMessage>> getMessagesAfter(
    String conversationId,
    DateTime after, {
    int limit = 50,
  }) async {
    final snapshot = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .where('timestamp', isGreaterThan: after.toIso8601String())
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return ChatMessage.fromJson(data);
    }).toList();
  }

  Future<void> markMessageAsRead(String conversationId, String messageId, String userId) async {
    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(messageId)
        .update({
      'readBy': FieldValue.arrayUnion([userId]),
      'status': MessageStatus.read.name,
    });
  }

  Future<void> markConversationAsRead(String conversationId, String userId) async {
    final messages = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .where('senderId', isNotEqualTo: userId)
        .where('readBy', whereNotIn: [userId])
        .get();

    final batch = _firestore.batch();
    for (var doc in messages.docs) {
      batch.update(doc.reference, {
        'readBy': FieldValue.arrayUnion([userId]),
      });
    }
    await batch.commit();

    await _firestore.collection('conversations').doc(conversationId).update({
      'unreadCount': 0,
    });
  }

  Future<void> muteConversation(String conversationId, String userId, bool mute) async {
    await _firestore.collection('conversations').doc(conversationId).update({
      'mutedBy.$userId': mute,
    });
  }

  Future<void> deleteConversation(String conversationId) async {
    await _firestore.collection('conversations').doc(conversationId).update({
      'isActive': false,
    });
  }

  Future<int> getUnreadMessageCount(String conversationId, String userId) async {
    final snapshot = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .where('senderId', isNotEqualTo: userId)
        .get();

    int unreadCount = 0;
    for (var doc in snapshot.docs) {
      final message = ChatMessage.fromJson(doc.data());
      if (!message.readBy.contains(userId)) {
        unreadCount++;
      }
    }
    return unreadCount;
  }

  Future<int> getTotalUnreadCount(String userId) async {
    final conversations = await getUserConversations(userId);
    int totalUnread = 0;
    
    for (var conversation in conversations) {
      if (conversation.mutedBy[userId] != true) {
        final unread = await getUnreadMessageCount(conversation.id, userId);
        totalUnread += unread;
      }
    }
    
    return totalUnread;
  }
}
