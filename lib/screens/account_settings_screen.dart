import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _isPrivateAccount = false;
  bool _showActivityStatus = true;
  bool _allowTagging = true;

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
          'Account Settings',
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
            title: 'Privacy',
            children: [
              _buildSwitchTile(
                icon: LucideIcons.lock,
                iconColor: const Color(0xFF6366F1),
                iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
                title: 'Private Account',
                subtitle: 'Only approved followers can see your activities',
                value: _isPrivateAccount,
                onChanged: (value) {
                  setState(() => _isPrivateAccount = value);
                  _showSnackBar(
                    'Private account ${value ? "enabled" : "disabled"}',
                  );
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.eye,
                iconColor: const Color(0xFF10B981),
                iconBgColor: const Color(0xFF10B981).withOpacity(0.1),
                title: 'Show Activity Status',
                subtitle: 'Let others see when you\'re active',
                value: _showActivityStatus,
                onChanged: (value) {
                  setState(() => _showActivityStatus = value);
                  _showSnackBar(
                    'Activity status ${value ? "visible" : "hidden"}',
                  );
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.tag,
                iconColor: const Color(0xFFF59E0B),
                iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
                title: 'Allow Tagging',
                subtitle: 'Others can tag you in activities',
                value: _allowTagging,
                onChanged: (value) {
                  setState(() => _allowTagging = value);
                  _showSnackBar('Tagging ${value ? "allowed" : "disabled"}');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Security',
            children: [
              _buildActionTile(
                icon: LucideIcons.key,
                iconColor: const Color(0xFF6366F1),
                iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () => _showChangePasswordDialog(),
              ),
              const Divider(height: 1),
              _buildActionTile(
                icon: LucideIcons.smartphone,
                iconColor: const Color(0xFF10B981),
                iconBgColor: const Color(0xFF10B981).withOpacity(0.1),
                title: 'Two-Factor Authentication',
                subtitle: 'Add an extra layer of security',
                onTap: () => _showSnackBar('Two-factor authentication setup'),
              ),
              const Divider(height: 1),
              _buildActionTile(
                icon: LucideIcons.shield,
                iconColor: const Color(0xFF06B6D4),
                iconBgColor: const Color(0xFF06B6D4).withOpacity(0.1),
                title: 'Login Activity',
                subtitle: 'See where you\'re logged in',
                onTap: () => _showSnackBar('Login activity'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Account Management',
            children: [
              _buildActionTile(
                icon: LucideIcons.download,
                iconColor: const Color(0xFF8B5CF6),
                iconBgColor: const Color(0xFF8B5CF6).withOpacity(0.1),
                title: 'Download Your Data',
                subtitle: 'Get a copy of your information',
                onTap: () => _showDownloadDataDialog(),
              ),
              const Divider(height: 1),
              _buildActionTile(
                icon: LucideIcons.userX,
                iconColor: const Color(0xFFF59E0B),
                iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
                title: 'Deactivate Account',
                subtitle: 'Temporarily disable your account',
                onTap: () => _showDeactivateDialog(),
              ),
              const Divider(height: 1),
              _buildActionTile(
                icon: LucideIcons.trash2,
                iconColor: const Color(0xFFEF4444),
                iconBgColor: const Color(0xFFEF4444).withOpacity(0.1),
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                onTap: () => _showDeleteAccountDialog(),
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

  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Password changed successfully');
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showDownloadDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Your Data'),
        content: const Text(
          'We\'ll prepare a copy of your data and send you a download link via email within 48 hours.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Data download request submitted');
            },
            child: const Text('Request Download'),
          ),
        ],
      ),
    );
  }

  void _showDeactivateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Account'),
        content: const Text(
          'Your account will be temporarily disabled. You can reactivate it anytime by logging in again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Account deactivated');
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFF59E0B),
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Account deletion requires email verification');
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Delete'),
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
