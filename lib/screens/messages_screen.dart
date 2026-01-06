import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

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
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                          onPressed: () {},
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
                            IconButton(
                              icon: const Icon(LucideIcons.search, color: Colors.white),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.messageSquarePlus, color: Colors.white),
                              onPressed: () {},
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
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(LucideIcons.users, color: Colors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Groups',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '5',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(LucideIcons.messageCircle, color: Colors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Unread',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'GROUP CHATS',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Icon(LucideIcons.chevronUp, color: Colors.grey[400], size: 20),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildChatItem(
                    'https://images.unsplash.com/photo-1623622863859-2931a6c3bc80?w=100',
                    'Hiking in George Bass',
                    'Perfect! Just paid my share 💸',
                    '7 participants',
                    '7 online',
                    '2m',
                    true,
                  ),
                  _buildChatItem(
                    'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=100',
                    'Beach Volleyball Squad',
                    'Same time next week?',
                    '8 participants',
                    '3 online',
                    '1h',
                    false,
                  ),
                  _buildChatItem(
                    'https://images.unsplash.com/photo-1501555088652-021faa106b9b?w=100',
                    'Weekend Warriors',
                    'Who\'s in for the camping trip?',
                    '12 participants',
                    '5 online',
                    '3h',
                    true,
                  ),
                  _buildChatItem(
                    'https://images.unsplash.com/photo-1452626038306-9aae5e071dd3?w=100',
                    'Morning Run Club',
                    '6 AM tomorrow at the park',
                    '6 participants',
                    '2 online',
                    '5h',
                    false,
                  ),
                  _buildChatItem(
                    'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=100',
                    'Foodies Adventure',
                    'Found an amazing new restaurant!',
                    '10 participants',
                    '',
                    '1d',
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(
    String imageUrl,
    String title,
    String message,
    String participants,
    String online,
    String time,
    bool hasUnread,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    LucideIcons.users,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      participants,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                    if (online.isNotEmpty) ...[
                      Text(
                        ' • ',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        online,
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (hasUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF9333EA),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
