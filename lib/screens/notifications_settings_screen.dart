import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  bool _activityInvites = true;
  bool _activityUpdates = true;
  bool _activityCancellations = true;

  bool _newMessages = true;
  bool _messageReplies = true;
  bool _groupMessages = true;

  bool _newFollowers = true;
  bool _friendRequests = true;
  bool _mentions = true;

  bool _weeklyDigest = true;
  bool _monthlyReport = false;
  bool _tipsAndTricks = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection(
            title: 'Notification Channels',
            children: [
              _buildSwitchTile(
                icon: LucideIcons.bell,
                iconColor: const Color(0xFF6366F1),
                iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
                title: 'Push Notifications',
                subtitle: 'Receive notifications on your device',
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() => _pushNotifications = value);
                  _showSnackBar(
                    'Push notifications ${value ? "enabled" : "disabled"}',
                  );
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.mail,
                iconColor: const Color(0xFF10B981),
                iconBgColor: const Color(0xFF10B981).withOpacity(0.1),
                title: 'Email Notifications',
                subtitle: 'Receive updates via email',
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() => _emailNotifications = value);
                  _showSnackBar(
                    'Email notifications ${value ? "enabled" : "disabled"}',
                  );
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.messageSquare,
                iconColor: const Color(0xFF06B6D4),
                iconBgColor: const Color(0xFF06B6D4).withOpacity(0.1),
                title: 'SMS Notifications',
                subtitle: 'Receive text messages for important updates',
                value: _smsNotifications,
                onChanged: (value) {
                  setState(() => _smsNotifications = value);
                  _showSnackBar(
                    'SMS notifications ${value ? "enabled" : "disabled"}',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Activity Notifications',
            children: [
              _buildSwitchTile(
                icon: LucideIcons.userPlus,
                iconColor: const Color(0xFF8B5CF6),
                iconBgColor: const Color(0xFF8B5CF6).withOpacity(0.1),
                title: 'Activity Invites',
                subtitle: 'When someone invites you to an activity',
                value: _activityInvites,
                onChanged: (value) => setState(() => _activityInvites = value),
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.refreshCw,
                iconColor: const Color(0xFF06B6D4),
                iconBgColor: const Color(0xFF06B6D4).withOpacity(0.1),
                title: 'Activity Updates',
                subtitle: 'Changes to activities you\'re attending',
                value: _activityUpdates,
                onChanged: (value) => setState(() => _activityUpdates = value),
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.xCircle,
                iconColor: const Color(0xFFEF4444),
                iconBgColor: const Color(0xFFEF4444).withOpacity(0.1),
                title: 'Activity Cancellations',
                subtitle: 'When an activity is cancelled',
                value: _activityCancellations,
                onChanged: (value) =>
                    setState(() => _activityCancellations = value),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Messages',
            children: [
              _buildSwitchTile(
                icon: LucideIcons.messageCircle,
                iconColor: const Color(0xFF10B981),
                iconBgColor: const Color(0xFF10B981).withOpacity(0.1),
                title: 'New Messages',
                subtitle: 'When you receive a new message',
                value: _newMessages,
                onChanged: (value) => setState(() => _newMessages = value),
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.reply,
                iconColor: const Color(0xFF6366F1),
                iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
                title: 'Message Replies',
                subtitle: 'When someone replies to your message',
                value: _messageReplies,
                onChanged: (value) => setState(() => _messageReplies = value),
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.users,
                iconColor: const Color(0xFF8B5CF6),
                iconBgColor: const Color(0xFF8B5CF6).withOpacity(0.1),
                title: 'Group Messages',
                subtitle: 'Messages in group chats',
                value: _groupMessages,
                onChanged: (value) => setState(() => _groupMessages = value),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Social',
            children: [
              _buildSwitchTile(
                icon: LucideIcons.userCheck,
                iconColor: const Color(0xFF10B981),
                iconBgColor: const Color(0xFF10B981).withOpacity(0.1),
                title: 'New Followers',
                subtitle: 'When someone follows you',
                value: _newFollowers,
                onChanged: (value) => setState(() => _newFollowers = value),
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.userPlus,
                iconColor: const Color(0xFF6366F1),
                iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
                title: 'Friend Requests',
                subtitle: 'When someone sends you a friend request',
                value: _friendRequests,
                onChanged: (value) => setState(() => _friendRequests = value),
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.atSign,
                iconColor: const Color(0xFFF59E0B),
                iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
                title: 'Mentions',
                subtitle: 'When someone mentions you',
                value: _mentions,
                onChanged: (value) => setState(() => _mentions = value),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Digest & Updates',
            children: [
              _buildSwitchTile(
                icon: LucideIcons.calendar,
                iconColor: const Color(0xFF8B5CF6),
                iconBgColor: const Color(0xFF8B5CF6).withOpacity(0.1),
                title: 'Weekly Digest',
                subtitle: 'Summary of your weekly activities',
                value: _weeklyDigest,
                onChanged: (value) => setState(() => _weeklyDigest = value),
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.barChart,
                iconColor: const Color(0xFF06B6D4),
                iconBgColor: const Color(0xFF06B6D4).withOpacity(0.1),
                title: 'Monthly Report',
                subtitle: 'Your monthly activity statistics',
                value: _monthlyReport,
                onChanged: (value) => setState(() => _monthlyReport = value),
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.lightbulb,
                iconColor: const Color(0xFFF59E0B),
                iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
                title: 'Tips & Tricks',
                subtitle: 'Get the most out of Fylo',
                value: _tipsAndTricks,
                onChanged: (value) => setState(() => _tipsAndTricks = value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
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
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF6366F1),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
