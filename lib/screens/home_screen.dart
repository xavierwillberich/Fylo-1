import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/event.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';
import '../widgets/event_card.dart';
import '../widgets/gradient_header.dart';
import '../core/widgets/app_error_view.dart';
import 'search_screen.dart';
import 'create_activity_screen.dart';
import 'activity_detail_screen.dart';
// import 'settings_screen.dart'; // 事项4: 清理 - 未使用
import 'support_screens.dart';
import 'user_profile_screen.dart';
import 'edit_profile_screen.dart' as edit_profile;
import 'account_settings_screen.dart' as account_settings;
import 'payment_screen.dart' as payment;
import 'notifications_settings_screen.dart' as notifications;
import 'permissions_screen.dart' as permissions;
import 'appearance_screen.dart' as appearance;
import 'language_screen.dart' as language;
import 'language_test_screen.dart' as language_test;
import 'qr_scanner_screen.dart';
import 'ai_assistant_screen.dart';
import 'contact_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLocation = '附近';
  final FirebaseService _firebaseService = FirebaseService();
  bool _isSigningOut = false;

  // P0-2 修复：使用 AuthService 单例获取当前用户 ID
  String? get _currentUserId => AuthService.instance.currentUserId;

  /// 任务1：真实登出逻辑
  Future<void> _handleSignOut(BuildContext dialogContext) async {
    if (_isSigningOut) return;

    // 先关闭对话框和 Drawer
    Navigator.pop(dialogContext);
    Navigator.pop(context);

    setState(() => _isSigningOut = true);

    try {
      await AuthService.instance.signOut();
      // 登出成功后，AuthProvider/AuthWrapper 会自动切换到 unauthenticated 状态
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '登出失败: ${e.toString().replaceAll('Exception: ', '')}',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  Map<String, List<Event>> _groupEvents(List<Event> events) {
    final Map<String, List<Event>> grouped = {};
    for (var event in events) {
      final key = '${event.date} ${event.month} ${event.year}';
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(event);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          GradientHeader(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (BuildContext ctx) {
                          return GestureDetector(
                            onTap: () {
                              Scaffold.of(ctx).openDrawer();
                            },
                            child: const CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
                              ),
                            ),
                          );
                        },
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
                              icon: const Icon(
                                LucideIcons.search,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SearchScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                LucideIcons.plus,
                                color: Color(0xFF9333EA),
                                size: 22,
                              ),
                              onPressed: () {
                                _showActionMenu(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Event>>(
              stream: _firebaseService.getEventsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  // P1-2: 使用统一错误视图
                  return AppErrorView.fromError(
                    snapshot.error,
                    onRetry: () => setState(() {}),
                  );
                }

                final allEvents = snapshot.data ?? [];
                final userId = _currentUserId;
                // Bug 1 修复：null 检查，未登录时不过滤用户活动
                final userEvents = userId != null
                    ? allEvents
                          .where(
                            (event) =>
                                event.creatorId == userId ||
                                event.participantIds.contains(userId),
                          )
                          .toList()
                    : <Event>[];
                final groupedUserEvents = _groupEvents(userEvents);
                final groupedAllEvents = _groupEvents(allEvents);

                return ListView(
                  padding: const EdgeInsets.only(bottom: 100),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Row(
                        children: [
                          const Text(
                            '你的活动',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            LucideIcons.chevronRight,
                            size: 20,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (userEvents.isEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                LucideIcons.ticket,
                                size: 28,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                '你的日程安排很空闲。浏览下方活动，\n或点击 + 创建活动。',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...groupedUserEvents.entries.map((entry) {
                        final eventList = entry.value;
                        final firstEvent = eventList.first;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${firstEvent.date}${firstEvent.month}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' / ${firstEvent.dayOfWeek}',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                children: eventList
                                    .map(
                                      (event) => EventCard(
                                        event: event,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ActivityDetailScreen(
                                                    event: event,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      }),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: const Text(
                        '为你推荐',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: GestureDetector(
                        onTap: () {
                          _showLocationPicker(context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedLocation,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              LucideIcons.chevronDown,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...groupedAllEvents.entries.map((entry) {
                      final eventList = entry.value;
                      final firstEvent = eventList.first;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${firstEvent.date}${firstEvent.month}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / ${firstEvent.dayOfWeek}',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              children: eventList
                                  .map(
                                    (event) => EventCard(
                                      event: event,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ActivityDetailScreen(
                                                  event: event,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showActionMenu(BuildContext context) {
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
                        icon: LucideIcons.scan,
                        title: '扫一扫',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QRScannerScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      _buildActionMenuItem(
                        icon: LucideIcons.plusCircle,
                        title: '创建活动',
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            isDismissible: true,
                            enableDrag: true,
                            builder: (context) => DraggableScrollableSheet(
                              initialChildSize: 0.92,
                              minChildSize: 0.5,
                              maxChildSize: 0.92,
                              builder: (context, scrollController) =>
                                  const CreateActivityScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      _buildActionMenuItem(
                        icon: LucideIcons.bot,
                        title: 'AI助手',
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            isDismissible: true,
                            enableDrag: true,
                            builder: (context) => DraggableScrollableSheet(
                              initialChildSize: 0.92,
                              minChildSize: 0.5,
                              maxChildSize: 0.92,
                              builder: (context, scrollController) =>
                                  const AIAssistantScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      _buildActionMenuItem(
                        icon: LucideIcons.users,
                        title: '创建群聊',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ContactSelectionScreen(),
                            ),
                          );
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
            Icon(icon, size: 20, color: const Color(0xFF1F2937)),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).padding.top + 200,
              left: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: Container(
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
                      _buildLocationOption('附近'),
                      Divider(height: 1, color: Colors.grey[200]),
                      _buildLocationOption('全球各地'),
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

  Widget _buildLocationOption(String location) {
    final isSelected = _selectedLocation == location;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLocation = location;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              LucideIcons.check,
              size: 20,
              color: isSelected ? Colors.black : Colors.transparent,
            ),
            const SizedBox(width: 16),
            Text(
              location,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.black : const Color(0xFF6B7280),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 事项4: 清理 - _buildHeaderButton 已移除（未使用）

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(color: const Color(0xFFF9FAFB), height: double.infinity),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top + 16),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserProfileScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF6366F1).withOpacity(0.8),
                                      const Color(0xFF9333EA).withOpacity(0.8),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'S',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sarah Chen',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                LucideIcons.chevronRight,
                                size: 20,
                                color: Color(0xFF9CA3AF),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildDrawerSettingsItem(
                              context: context,
                              icon: LucideIcons.user,
                              iconColor: const Color(0xFF6366F1),
                              iconBgColor: const Color(
                                0xFF6366F1,
                              ).withOpacity(0.1),
                              title: 'Edit Profile',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const edit_profile.EditProfileScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDrawerDivider(),
                            _buildDrawerSettingsItem(
                              context: context,
                              icon: LucideIcons.settings,
                              iconColor: const Color(0xFF6B7280),
                              iconBgColor: const Color(
                                0xFF6B7280,
                              ).withOpacity(0.1),
                              title: 'Account Settings',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const account_settings.AccountSettingsScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDrawerDivider(),
                            _buildDrawerSettingsItem(
                              context: context,
                              icon: LucideIcons.creditCard,
                              iconColor: const Color(0xFFEC4899),
                              iconBgColor: const Color(
                                0xFFEC4899,
                              ).withOpacity(0.1),
                              title: 'Payment',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const payment.PaymentScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Preferences',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildDrawerSettingsItem(
                              context: context,
                              icon: LucideIcons.bell,
                              iconColor: const Color(0xFFEF4444),
                              iconBgColor: const Color(
                                0xFFEF4444,
                              ).withOpacity(0.1),
                              title: 'Notifications',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const notifications.NotificationsSettingsScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDrawerDivider(),
                            _buildDrawerSettingsItem(
                              context: context,
                              icon: LucideIcons.checkCircle,
                              iconColor: const Color(0xFF10B981),
                              iconBgColor: const Color(
                                0xFF10B981,
                              ).withOpacity(0.1),
                              title: 'Permissions',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const permissions.PermissionsScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDrawerDivider(),
                            _buildDrawerSettingsItem(
                              context: context,
                              icon: LucideIcons.palette,
                              iconColor: const Color(0xFFEC4899),
                              iconBgColor: const Color(
                                0xFFEC4899,
                              ).withOpacity(0.1),
                              title: 'Appearance',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const appearance.AppearanceScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDrawerDivider(),
                            _buildDrawerSettingsItem(
                              context: context,
                              icon: LucideIcons.globe,
                              iconColor: const Color(0xFF6366F1),
                              iconBgColor: const Color(
                                0xFF6366F1,
                              ).withOpacity(0.1),
                              title: 'Language',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const language.LanguageScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDrawerDivider(),
                            _buildDrawerSettingsItem(
                              context: context,
                              icon: LucideIcons.beaker,
                              iconColor: const Color(0xFFF59E0B),
                              iconBgColor: const Color(
                                0xFFF59E0B,
                              ).withOpacity(0.1),
                              title: 'Language Test',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const language_test.LanguageTestScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Resources',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildDrawerSettingsItem(
                              context: context,
                              icon: LucideIcons.headphones,
                              iconColor: const Color(0xFF06B6D4),
                              iconBgColor: const Color(
                                0xFF06B6D4,
                              ).withOpacity(0.1),
                              title: 'Contact Support',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ContactSupportScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDrawerDivider(),
                            _buildDrawerSettingsItem(
                              context: context,
                              icon: LucideIcons.award,
                              iconColor: const Color(0xFFF59E0B),
                              iconBgColor: const Color(
                                0xFFF59E0B,
                              ).withOpacity(0.1),
                              title: 'Get Academic Badge',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const GetAcademicBadgeScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDrawerDivider(),
                            _buildDrawerSettingsItem(
                              context: context,
                              icon: LucideIcons.messageSquare,
                              iconColor: const Color(0xFF06B6D4),
                              iconBgColor: const Color(
                                0xFF06B6D4,
                              ).withOpacity(0.1),
                              title: 'Send Feedback to Team',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SendFeedbackScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Account',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: _buildDrawerSettingsItem(
                          context: context,
                          icon: LucideIcons.logOut,
                          iconColor: const Color(0xFFEF4444),
                          iconBgColor: const Color(0xFFEF4444).withOpacity(0.1),
                          title: 'Sign Out',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Sign Out'),
                                content: const Text(
                                  'Are you sure you want to sign out?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: _isSigningOut
                                        ? null
                                        : () => _handleSignOut(context),
                                    child: _isSigningOut
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Color(0xFFEF4444),
                                            ),
                                          )
                                        : const Text(
                                            'Sign Out',
                                            style: TextStyle(
                                              color: Color(0xFFEF4444),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            );
                          },
                          showChevron: false,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: MediaQuery.of(context).size.height + 200,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSettingsItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required VoidCallback onTap,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            if (showChevron)
              const Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: Color(0xFF9CA3AF),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Container(height: 1, color: const Color(0xFFF3F4F6)),
    );
  }

  // 事项4: 清理 - _showFeatureMessage 已移除（Sign Out 已接入真实登出逻辑）
}
