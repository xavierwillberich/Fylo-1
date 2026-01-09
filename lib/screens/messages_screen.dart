import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'chat_detail_screen.dart';
import '../models/notification.dart';
import 'notifications_screen.dart';
import 'add_contact_screen.dart';
import 'contact_selection_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool isGroupChatsCollapsed = false;
  bool isDirectMessagesCollapsed = false;
  bool isNotificationsCollapsed = false;
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _notificationsKey = GlobalKey();
  final GlobalKey _groupChatsKey = GlobalKey();
  final GlobalKey _directMessagesKey = GlobalKey();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  List<Map<String, dynamic>> get filteredGroupChats {
    if (_searchController.text.isEmpty) return groupChats;
    return groupChats.where((chat) {
      return chat['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
             chat['lastMessage'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> get filteredPrivateChats {
    if (_searchController.text.isEmpty) return privateChats;
    return privateChats.where((chat) {
      return chat['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
             chat['lastMessage'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> get filteredNotifications {
    if (_searchController.text.isEmpty) return notifications;
    return notifications.where((notification) {
      return notification['title'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
             notification['message'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();
  }

  final List<Map<String, dynamic>> groupChats = [
    {
      'id': 'g1',
      'name': 'Hiking in George Bass',
      'avatar': 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=100&h=100&fit=crop',
      'lastMessage': 'Perfect! Just paid my share 💸',
      'time': '2m',
      'isUnread': true,
      'participants': 7,
      'onlineCount': 7,
    },
    {
      'id': 'g2',
      'name': 'Beach Volleyball Squad',
      'avatar': 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=100&h=100&fit=crop',
      'lastMessage': 'Same time next week?',
      'time': '1h',
      'isUnread': false,
      'participants': 8,
      'onlineCount': 3,
    },
    {
      'id': 'g3',
      'name': 'Weekend Warriors',
      'avatar': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=100&h=100&fit=crop',
      'lastMessage': 'Who\'s in for the camping trip?',
      'time': '3h',
      'isUnread': true,
      'participants': 12,
      'onlineCount': 5,
    },
    {
      'id': 'g4',
      'name': 'Morning Run Club',
      'avatar': 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=100&h=100&fit=crop',
      'lastMessage': '6 AM tomorrow at the park',
      'time': '5h',
      'isUnread': false,
      'participants': 6,
      'onlineCount': 2,
    },
    {
      'id': 'g5',
      'name': 'Foodies Adventure',
      'avatar': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=100&h=100&fit=crop',
      'lastMessage': 'Found an amazing new restaurant!',
      'time': '1d',
      'isUnread': false,
      'participants': 10,
      'onlineCount': 0,
    },
  ];

  final List<Map<String, dynamic>> privateChats = [
    {
      'id': 'p1',
      'name': 'Sarah Johnson',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
      'lastMessage': 'See you at the event tomorrow!',
      'time': '30m',
      'isUnread': true,
    },
    {
      'id': 'p2',
      'name': 'Mike Chen',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
      'lastMessage': 'Thanks for the recommendation 👍',
      'time': '2h',
      'isUnread': false,
    },
    {
      'id': 'p3',
      'name': 'Emma Wilson',
      'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop',
      'lastMessage': 'That hiking trail was amazing!',
      'time': '1d',
      'isUnread': false,
    },
  ];

  final List<Map<String, dynamic>> notifications = [
    {
      'id': 'n1',
      'type': NotificationType.invitation,
      'title': 'New Activity Invitation',
      'message': 'Sarah invited you to "Beach Volleyball"',
      'time': '5m',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
      'isRead': false,
    },
    {
      'id': 'n2',
      'type': NotificationType.activityUpdate,
      'title': 'Activity Update',
      'message': 'Hiking in George Bass starts in 2 hours',
      'time': '1h',
      'avatar': 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=100&h=100&fit=crop',
      'isRead': false,
    },
    {
      'id': 'n3',
      'type': NotificationType.newFollower,
      'title': 'New Follower',
      'message': 'Mike Chen started following you',
      'time': '3h',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
      'isRead': true,
    },
    {
      'id': 'n4',
      'type': NotificationType.like,
      'title': 'Activity Liked',
      'message': 'Emma liked your "Morning Run Club" activity',
      'time': '5h',
      'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop',
      'isRead': true,
    },
  ];

  int get unreadCount {
    int count = 0;
    for (var chat in filteredGroupChats) {
      if (chat['isUnread'] == true) count++;
    }
    for (var chat in filteredPrivateChats) {
      if (chat['isUnread'] == true) count++;
    }
    return count;
  }

  int get unreadNotificationsCount {
    int count = 0;
    for (var notification in filteredNotifications) {
      if (notification['isRead'] == false) count++;
    }
    return count;
  }

  void _showAddMessageMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).padding.top + 60,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionMenuItem(
                        icon: LucideIcons.userPlus,
                        title: 'Add Contact',
                        onTap: () async {
                          Navigator.pop(context);
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddContactScreen(),
                            ),
                          );
                          if (result != null && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Contact added: ${result['name']}'),
                                backgroundColor: const Color(0xFF10B981),
                              ),
                            );
                          }
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      _buildActionMenuItem(
                        icon: LucideIcons.users,
                        title: 'Create Group Chat',
                        onTap: () async {
                          Navigator.pop(context);
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ContactSelectionScreen(),
                            ),
                          );
                          if (result != null && mounted) {
                            setState(() {
                              groupChats.insert(0, {
                                'id': 'g${groupChats.length + 1}',
                                'name': result['groupName'],
                                'avatar': 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=100&h=100&fit=crop',
                                'lastMessage': 'Group created',
                                'time': 'now',
                                'isUnread': false,
                                'participants': (result['selectedContacts'] as List).length + 1,
                                'onlineCount': 0,
                              });
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Group "${result['groupName']}" created'),
                                backgroundColor: const Color(0xFF10B981),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF1F2937),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1F2937),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFF3F4F6),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                color: Color(0xFF9CA3AF),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF9333EA),
                  Color(0xFFEC4899),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Messages',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(isSearching ? LucideIcons.x : LucideIcons.search, color: Colors.white, size: 20),
                                onPressed: () {
                                  setState(() {
                                    isSearching = !isSearching;
                                    if (!isSearching) {
                                      _searchController.clear();
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(LucideIcons.messageSquarePlus, color: Colors.white, size: 20),
                                onPressed: () {
                                  _showAddMessageMenu(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isSearching)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isGroupChatsCollapsed = false;
                                    });
                                    _scrollToSection(_groupChatsKey);
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  splashColor: Colors.white.withOpacity(0.3),
                                  highlightColor: Colors.white.withOpacity(0.1),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.25),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Icon(
                                                LucideIcons.users,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Text(
                                              'Groups',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${groupChats.length}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isGroupChatsCollapsed = false;
                                      isDirectMessagesCollapsed = false;
                                    });
                                    Future.delayed(const Duration(milliseconds: 100), () {
                                      _scrollToSection(_groupChatsKey);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  splashColor: Colors.white.withOpacity(0.3),
                                  highlightColor: Colors.white.withOpacity(0.1),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.25),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Icon(
                                                LucideIcons.messageCircle,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Text(
                                              'Unread',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '$unreadCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isNotificationsCollapsed = false;
                                    });
                                    _scrollToSection(_notificationsKey);
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  splashColor: Colors.white.withOpacity(0.3),
                                  highlightColor: Colors.white.withOpacity(0.1),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.25),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Icon(
                                                LucideIcons.bell,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Text(
                                              'Alerts',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '$unreadNotificationsCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                if (isSearching)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search messages...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                        prefixIcon: const Icon(LucideIcons.search, color: Colors.white, size: 20),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                children: [
                  Container(
                    key: _notificationsKey,
                    child: _buildSectionHeader('NOTIFICATIONS', isNotificationsCollapsed, () {
                      setState(() {
                        isNotificationsCollapsed = !isNotificationsCollapsed;
                      });
                    }),
                  ),
                  const SizedBox(height: 16),
                  if (!isNotificationsCollapsed)
                    ...filteredNotifications.map((notification) => _buildNotificationItem(notification)).toList(),
                  const SizedBox(height: 24),
                  Container(
                    key: _groupChatsKey,
                    child: _buildSectionHeader('GROUP CHATS', isGroupChatsCollapsed, () {
                      setState(() {
                        isGroupChatsCollapsed = !isGroupChatsCollapsed;
                      });
                    }),
                  ),
                  const SizedBox(height: 16),
                  if (!isGroupChatsCollapsed)
                    ...filteredGroupChats.map((chat) => _buildGroupChatItem(chat)).toList(),
                  const SizedBox(height: 24),
                  Container(
                    key: _directMessagesKey,
                    child: _buildSectionHeader('DIRECT MESSAGES', isDirectMessagesCollapsed, () {
                      setState(() {
                        isDirectMessagesCollapsed = !isDirectMessagesCollapsed;
                      });
                    }),
                  ),
                  const SizedBox(height: 16),
                  if (!isDirectMessagesCollapsed)
                    ...filteredPrivateChats.map((chat) => _buildPrivateChatItem(chat)).toList(),
                ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isCollapsed, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isCollapsed ? LucideIcons.chevronDown : LucideIcons.chevronUp,
                color: Colors.grey[400],
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupChatItem(Map<String, dynamic> chat) {
    final bool isUnread = chat['isUnread'] ?? false;
    final int onlineCount = chat['onlineCount'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isUnread
            ? const Color(0xFFF0F9FF)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(chat: chat),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isUnread
                    ? const Color(0xFFBAE6FD)
                    : const Color(0xFFF3F4F6),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        chat['avatar'],
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              LucideIcons.users,
                              color: Colors.white,
                              size: 24,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          LucideIcons.users,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: isUnread ? Colors.black : const Color(0xFF111827),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            chat['time'],
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chat['lastMessage'],
                        style: TextStyle(
                          color: isUnread ? const Color(0xFF374151) : const Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${chat['participants']} participants',
                              style: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (onlineCount > 0) ...[
                            const Text(
                              ' • ',
                              style: TextStyle(
                                color: Color(0xFFD1D5DB),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '$onlineCount online',
                              style: const TextStyle(
                                color: Color(0xFF10B981),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (isUnread)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivateChatItem(Map<String, dynamic> chat) {
    final bool isUnread = chat['isUnread'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isUnread
            ? const Color(0xFFF0F9FF)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(chat: chat),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isUnread
                    ? const Color(0xFFBAE6FD)
                    : const Color(0xFFF3F4F6),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        chat['avatar'],
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              LucideIcons.user,
                              color: Colors.white,
                              size: 24,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: isUnread ? Colors.black : const Color(0xFF111827),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            chat['time'],
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chat['lastMessage'],
                        style: TextStyle(
                          color: isUnread ? const Color(0xFF374151) : const Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isUnread)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final bool isRead = notification['isRead'] ?? true;
    final NotificationType type = notification['type'];

    IconData getIconForType(NotificationType type) {
      switch (type) {
        case NotificationType.invitation:
          return LucideIcons.userPlus;
        case NotificationType.activityUpdate:
          return LucideIcons.calendar;
        case NotificationType.newFollower:
          return LucideIcons.userCheck;
        case NotificationType.like:
          return LucideIcons.heart;
        case NotificationType.comment:
          return LucideIcons.messageCircle;
        case NotificationType.reminder:
          return LucideIcons.clock;
      }
    }

    Color getColorForType(NotificationType type) {
      switch (type) {
        case NotificationType.invitation:
          return const Color(0xFF3B82F6);
        case NotificationType.activityUpdate:
          return const Color(0xFF9333EA);
        case NotificationType.newFollower:
          return const Color(0xFF10B981);
        case NotificationType.like:
          return const Color(0xFFEC4899);
        case NotificationType.comment:
          return const Color(0xFF06B6D4);
        case NotificationType.reminder:
          return const Color(0xFFF59E0B);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: !isRead
            ? const Color(0xFFFEF3F2)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: !isRead
                    ? const Color(0xFFFECDCA)
                    : const Color(0xFFF3F4F6),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        notification['avatar'],
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: getColorForType(type),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              getIconForType(type),
                              color: Colors.white,
                              size: 24,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: getColorForType(type),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          getIconForType(type),
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: !isRead ? Colors.black : const Color(0xFF111827),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            notification['time'],
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['message'],
                        style: TextStyle(
                          color: !isRead ? const Color(0xFF374151) : const Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!isRead)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6B6B),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
