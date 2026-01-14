import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../core/widgets/app_error_view.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  bool _isLoading = true;
  String? _error;

  String? get _currentUserId => AuthService.instance.currentUserId;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final userId = _currentUserId;
    if (userId == null) {
      setState(() {
        _isLoading = false;
        _error = '请先登录';
      });
      return;
    }

    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('notifications')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _pushNotifications = data['pushNotifications'] ?? true;
          _emailNotifications = data['emailNotifications'] ?? true;
          _smsNotifications = data['smsNotifications'] ?? false;
          _activityInvites = data['activityInvites'] ?? true;
          _activityUpdates = data['activityUpdates'] ?? true;
          _activityCancellations = data['activityCancellations'] ?? true;
          _newMessages = data['newMessages'] ?? true;
          _messageReplies = data['messageReplies'] ?? true;
          _groupMessages = data['groupMessages'] ?? true;
          _newFollowers = data['newFollowers'] ?? true;
          _friendRequests = data['friendRequests'] ?? true;
          _mentions = data['mentions'] ?? true;
          _weeklyDigest = data['weeklyDigest'] ?? true;
          _monthlyReport = data['monthlyReport'] ?? false;
          _tipsAndTricks = data['tipsAndTricks'] ?? true;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _savePreference(String key, bool value) async {
    final userId = _currentUserId;
    if (userId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('notifications')
          .set({key: value}, SetOptions(merge: true));
    } catch (e) {
      _showSnackBar('保存失败: $e');
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: _buildAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: _buildAppBar(),
        body: AppErrorView(
          title: '加载失败',
          message: _error!,
          onRetry: () {
            setState(() {
              _isLoading = true;
              _error = null;
            });
            _loadPreferences();
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: _buildAppBar(),
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
                  _savePreference('pushNotifications', value);
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
                  _savePreference('emailNotifications', value);
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
                  _savePreference('smsNotifications', value);
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
                onChanged: (value) {
                  setState(() => _activityInvites = value);
                  _savePreference('activityInvites', value);
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.refreshCw,
                iconColor: const Color(0xFF06B6D4),
                iconBgColor: const Color(0xFF06B6D4).withOpacity(0.1),
                title: 'Activity Updates',
                subtitle: 'Changes to activities you\'re attending',
                value: _activityUpdates,
                onChanged: (value) {
                  setState(() => _activityUpdates = value);
                  _savePreference('activityUpdates', value);
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.xCircle,
                iconColor: const Color(0xFFEF4444),
                iconBgColor: const Color(0xFFEF4444).withOpacity(0.1),
                title: 'Activity Cancellations',
                subtitle: 'When an activity is cancelled',
                value: _activityCancellations,
                onChanged: (value) {
                  setState(() => _activityCancellations = value);
                  _savePreference('activityCancellations', value);
                },
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
                onChanged: (value) {
                  setState(() => _newMessages = value);
                  _savePreference('newMessages', value);
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.reply,
                iconColor: const Color(0xFF6366F1),
                iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
                title: 'Message Replies',
                subtitle: 'When someone replies to your message',
                value: _messageReplies,
                onChanged: (value) {
                  setState(() => _messageReplies = value);
                  _savePreference('messageReplies', value);
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.users,
                iconColor: const Color(0xFF8B5CF6),
                iconBgColor: const Color(0xFF8B5CF6).withOpacity(0.1),
                title: 'Group Messages',
                subtitle: 'Messages in group chats',
                value: _groupMessages,
                onChanged: (value) {
                  setState(() => _groupMessages = value);
                  _savePreference('groupMessages', value);
                },
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
                onChanged: (value) {
                  setState(() => _newFollowers = value);
                  _savePreference('newFollowers', value);
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.userPlus,
                iconColor: const Color(0xFF6366F1),
                iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
                title: 'Friend Requests',
                subtitle: 'When someone sends you a friend request',
                value: _friendRequests,
                onChanged: (value) {
                  setState(() => _friendRequests = value);
                  _savePreference('friendRequests', value);
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.atSign,
                iconColor: const Color(0xFFF59E0B),
                iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
                title: 'Mentions',
                subtitle: 'When someone mentions you',
                value: _mentions,
                onChanged: (value) {
                  setState(() => _mentions = value);
                  _savePreference('mentions', value);
                },
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
                onChanged: (value) {
                  setState(() => _weeklyDigest = value);
                  _savePreference('weeklyDigest', value);
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.barChart,
                iconColor: const Color(0xFF06B6D4),
                iconBgColor: const Color(0xFF06B6D4).withOpacity(0.1),
                title: 'Monthly Report',
                subtitle: 'Your monthly activity statistics',
                value: _monthlyReport,
                onChanged: (value) {
                  setState(() => _monthlyReport = value);
                  _savePreference('monthlyReport', value);
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.lightbulb,
                iconColor: const Color(0xFFF59E0B),
                iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
                title: 'Tips & Tricks',
                subtitle: 'Get the most out of Fylo',
                value: _tipsAndTricks,
                onChanged: (value) {
                  setState(() => _tipsAndTricks = value);
                  _savePreference('tipsAndTricks', value);
                },
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
