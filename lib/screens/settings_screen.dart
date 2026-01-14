import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/auth_service.dart';
import 'edit_profile_screen.dart';
import 'account_settings_screen.dart';
import 'notifications_settings_screen.dart';
import 'permissions_screen.dart';
import 'appearance_screen.dart';
import 'language_screen.dart';
import 'support_screens.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isSigningOut = false;

  // 任务A: 获取当前用户信息
  String get _userName {
    final user = AuthService.instance.currentUser;
    if (user == null) return 'User';
    return user.displayName ?? user.email?.split('@').first ?? 'User';
  }

  String get _userInitial {
    final name = _userName;
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  String? get _userPhotoUrl => AuthService.instance.currentUser?.photoURL;

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature 功能即将上线'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: '知道了',
          onPressed: () {},
        ),
      ),
    );
  }

  /// 任务1：真实登出逻辑
  Future<void> _handleSignOut(BuildContext dialogContext) async {
    if (_isSigningOut) return;
    
    Navigator.pop(dialogContext); // 关闭对话框
    
    setState(() => _isSigningOut = true);
    
    try {
      await AuthService.instance.signOut();
      // 登出成功后，AuthProvider/AuthWrapper 会自动切换到 unauthenticated 状态
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('登出失败: ${e.toString().replaceAll('Exception: ', '')}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft, size: 24),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Expanded(
                    child: Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // 任务B: 用户信息区域 - 使用真实用户数据
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            // 用户头像
                            _userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      _userPhotoUrl!,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(),
                                    ),
                                  )
                                : _buildAvatarPlaceholder(),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _userName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
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
                          // 任务A: 接入真实页面
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.user,
                            iconColor: const Color(0xFF6366F1),
                            iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
                            title: 'Edit Profile',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                            ),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.settings,
                            iconColor: const Color(0xFF6B7280),
                            iconBgColor: const Color(0xFF6B7280).withOpacity(0.1),
                            title: 'Account Settings',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
                            ),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.creditCard,
                            iconColor: const Color(0xFFEC4899),
                            iconBgColor: const Color(0xFFEC4899).withOpacity(0.1),
                            title: 'Payment',
                            subtitle: 'Coming Soon',
                            onTap: () => _showComingSoon(context, 'Payment'),
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
                          // 任务A: Preferences 接入真实页面
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.bell,
                            iconColor: const Color(0xFFEF4444),
                            iconBgColor: const Color(0xFFEF4444).withOpacity(0.1),
                            title: 'Notifications',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen()),
                            ),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.checkCircle,
                            iconColor: const Color(0xFF10B981),
                            iconBgColor: const Color(0xFF10B981).withOpacity(0.1),
                            title: 'Permissions',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PermissionsScreen()),
                            ),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.palette,
                            iconColor: const Color(0xFFEC4899),
                            iconBgColor: const Color(0xFFEC4899).withOpacity(0.1),
                            title: 'Appearance',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AppearanceScreen()),
                            ),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.globe,
                            iconColor: const Color(0xFF6366F1),
                            iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
                            title: 'Language',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LanguageScreen()),
                            ),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.beaker,
                            iconColor: const Color(0xFFF59E0B),
                            iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
                            title: 'Language Test',
                            subtitle: 'Coming Soon',
                            onTap: () => _showComingSoon(context, 'Language Test'),
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
                          // 任务A: Resources 接入真实页面
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.headphones,
                            iconColor: const Color(0xFF06B6D4),
                            iconBgColor: const Color(0xFF06B6D4).withOpacity(0.1),
                            title: 'Contact Support',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ContactSupportScreen()),
                            ),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.award,
                            iconColor: const Color(0xFFF59E0B),
                            iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
                            title: 'Get Academic Badge',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const GetAcademicBadgeScreen()),
                            ),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.messageSquare,
                            iconColor: const Color(0xFF06B6D4),
                            iconBgColor: const Color(0xFF06B6D4).withOpacity(0.1),
                            title: 'Send Feedback to Team',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SendFeedbackScreen()),
                            ),
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
                      child: _buildSettingsItem(
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
                              content: const Text('Are you sure you want to sign out?'),
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
                                      : const Text('Sign Out', style: TextStyle(color: Color(0xFFEF4444))),
                                ),
                              ],
                            ),
                          );
                        },
                        showChevron: false,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 任务B: 头像占位符
  Widget _buildAvatarPlaceholder() {
    return Container(
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
      child: Center(
        child: Text(
          _userInitial,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? subtitle,
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
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
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
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ],
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

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Container(
        height: 1,
        color: const Color(0xFFF3F4F6),
      ),
    );
  }
}
