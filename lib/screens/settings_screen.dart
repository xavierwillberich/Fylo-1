import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showFeatureMessage(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
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
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.user,
                            iconColor: const Color(0xFF6366F1),
                            iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
                            title: 'Edit Profile',
                            onTap: () => _showFeatureMessage(context, 'Edit Profile'),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.settings,
                            iconColor: const Color(0xFF6B7280),
                            iconBgColor: const Color(0xFF6B7280).withOpacity(0.1),
                            title: 'Account Settings',
                            onTap: () => _showFeatureMessage(context, 'Account Settings'),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.creditCard,
                            iconColor: const Color(0xFFEC4899),
                            iconBgColor: const Color(0xFFEC4899).withOpacity(0.1),
                            title: 'Payment',
                            onTap: () => _showFeatureMessage(context, 'Payment'),
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
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.bell,
                            iconColor: const Color(0xFFEF4444),
                            iconBgColor: const Color(0xFFEF4444).withOpacity(0.1),
                            title: 'Notifications',
                            onTap: () => _showFeatureMessage(context, 'Notifications'),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.checkCircle,
                            iconColor: const Color(0xFF10B981),
                            iconBgColor: const Color(0xFF10B981).withOpacity(0.1),
                            title: 'Permissions',
                            onTap: () => _showFeatureMessage(context, 'Permissions'),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.palette,
                            iconColor: const Color(0xFFEC4899),
                            iconBgColor: const Color(0xFFEC4899).withOpacity(0.1),
                            title: 'Appearance',
                            onTap: () => _showFeatureMessage(context, 'Appearance'),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.globe,
                            iconColor: const Color(0xFF6366F1),
                            iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
                            title: 'Language',
                            onTap: () => _showFeatureMessage(context, 'Language'),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.beaker,
                            iconColor: const Color(0xFFF59E0B),
                            iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
                            title: 'Language Test',
                            onTap: () => _showFeatureMessage(context, 'Language Test'),
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
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.headphones,
                            iconColor: const Color(0xFF06B6D4),
                            iconBgColor: const Color(0xFF06B6D4).withOpacity(0.1),
                            title: 'Contact Support',
                            onTap: () => _showFeatureMessage(context, 'Contact Support'),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.award,
                            iconColor: const Color(0xFFF59E0B),
                            iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
                            title: 'Get Academic Badge',
                            onTap: () => _showFeatureMessage(context, 'Get Academic Badge'),
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            context: context,
                            icon: LucideIcons.messageSquare,
                            iconColor: const Color(0xFF06B6D4),
                            iconBgColor: const Color(0xFF06B6D4).withOpacity(0.1),
                            title: 'Send Feedback to Team',
                            onTap: () => _showFeatureMessage(context, 'Send Feedback to Team'),
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
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showFeatureMessage(context, 'Sign Out');
                                  },
                                  child: const Text('Sign Out', style: TextStyle(color: Color(0xFFEF4444))),
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

  Widget _buildSettingsItem({
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
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
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
