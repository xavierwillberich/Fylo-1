import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'chat_detail_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool isGroupChatsCollapsed = false;
  bool isDirectMessagesCollapsed = false;

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

  int get unreadCount {
    int count = 0;
    for (var chat in groupChats) {
      if (chat['isUnread'] == true) count++;
    }
    for (var chat in privateChats) {
      if (chat['isUnread'] == true) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Text(
                          'Messages',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(LucideIcons.search, color: Colors.white),
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(LucideIcons.messageSquarePlus, color: Colors.white),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        LucideIcons.users,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Groups',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      '${groupChats.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        LucideIcons.messageCircle,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Unread',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      '$unreadCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                children: [
                  _buildSectionHeader('GROUP CHATS', isGroupChatsCollapsed, () {
                    setState(() {
                      isGroupChatsCollapsed = !isGroupChatsCollapsed;
                    });
                  }),
                  const SizedBox(height: 16),
                  if (!isGroupChatsCollapsed)
                    ...groupChats.map((chat) => _buildGroupChatItem(chat)).toList(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('DIRECT MESSAGES', isDirectMessagesCollapsed, () {
                    setState(() {
                      isDirectMessagesCollapsed = !isDirectMessagesCollapsed;
                    });
                  }),
                  const SizedBox(height: 16),
                  if (!isDirectMessagesCollapsed)
                    ...privateChats.map((chat) => _buildPrivateChatItem(chat)).toList(),
                ],
              ),
            ),
          ],
        ),
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
                            ),
                          ),
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
                          Text(
                            '${chat['participants']} participants',
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
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
                            ),
                          ),
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
}
