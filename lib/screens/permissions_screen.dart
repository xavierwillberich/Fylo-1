import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final List<PermissionItem> _permissions = [
    PermissionItem(
      icon: LucideIcons.mapPin,
      iconColor: const Color(0xFFEF4444),
      iconBgColor: const Color(0xFFEF4444).withOpacity(0.1),
      title: 'Location',
      description: 'Used to find activities near you',
      status: PermissionStatus.granted,
    ),
    PermissionItem(
      icon: LucideIcons.camera,
      iconColor: const Color(0xFF6366F1),
      iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
      title: 'Camera',
      description: 'Take photos for your profile and activities',
      status: PermissionStatus.granted,
    ),
    PermissionItem(
      icon: LucideIcons.image,
      iconColor: const Color(0xFF8B5CF6),
      iconBgColor: const Color(0xFF8B5CF6).withOpacity(0.1),
      title: 'Photos',
      description: 'Access photos from your library',
      status: PermissionStatus.granted,
    ),
    PermissionItem(
      icon: LucideIcons.bell,
      iconColor: const Color(0xFFF59E0B),
      iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
      title: 'Notifications',
      description: 'Receive updates about activities and messages',
      status: PermissionStatus.granted,
    ),
    PermissionItem(
      icon: LucideIcons.mic,
      iconColor: const Color(0xFF10B981),
      iconBgColor: const Color(0xFF10B981).withOpacity(0.1),
      title: 'Microphone',
      description: 'Record audio messages',
      status: PermissionStatus.denied,
    ),
    PermissionItem(
      icon: LucideIcons.users,
      iconColor: const Color(0xFF06B6D4),
      iconBgColor: const Color(0xFF06B6D4).withOpacity(0.1),
      title: 'Contacts',
      description: 'Find friends who are already on Fylo',
      status: PermissionStatus.notAsked,
    ),
    PermissionItem(
      icon: LucideIcons.calendar,
      iconColor: const Color(0xFFEC4899),
      iconBgColor: const Color(0xFFEC4899).withOpacity(0.1),
      title: 'Calendar',
      description: 'Add activities to your calendar',
      status: PermissionStatus.notAsked,
    ),
  ];

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
          'Permissions',
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    LucideIcons.info,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Manage app permissions to control what data Fylo can access on your device.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: _permissions.map((permission) {
                final index = _permissions.indexOf(permission);
                return Column(
                  children: [
                    _buildPermissionTile(permission),
                    if (index < _permissions.length - 1)
                      const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionTile(PermissionItem permission) {
    return InkWell(
      onTap: () => _handlePermissionTap(permission),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: permission.iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                permission.icon,
                size: 24,
                color: permission.iconColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    permission.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    permission.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildStatusBadge(permission.status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(PermissionStatus status) {
    Color bgColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case PermissionStatus.granted:
        bgColor = const Color(0xFF10B981).withOpacity(0.1);
        textColor = const Color(0xFF10B981);
        text = 'Granted';
        icon = LucideIcons.checkCircle;
        break;
      case PermissionStatus.denied:
        bgColor = const Color(0xFFEF4444).withOpacity(0.1);
        textColor = const Color(0xFFEF4444);
        text = 'Denied';
        icon = LucideIcons.xCircle;
        break;
      case PermissionStatus.notAsked:
        bgColor = const Color(0xFF6B7280).withOpacity(0.1);
        textColor = const Color(0xFF6B7280);
        text = 'Not Set';
        icon = LucideIcons.minusCircle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePermissionTap(PermissionItem permission) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: permission.iconBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                permission.icon,
                size: 32,
                color: permission.iconColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              permission.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              permission.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            if (permission.status == PermissionStatus.granted)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _revokePermission(permission);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Revoke Permission',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _requestPermission(permission);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Grant Permission',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _requestPermission(PermissionItem permission) {
    setState(() {
      permission.status = PermissionStatus.granted;
    });
    _showSnackBar('${permission.title} permission granted');
  }

  void _revokePermission(PermissionItem permission) {
    setState(() {
      permission.status = PermissionStatus.denied;
    });
    _showSnackBar('${permission.title} permission revoked');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class PermissionItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String description;
  PermissionStatus status;

  PermissionItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.description,
    required this.status,
  });
}

enum PermissionStatus {
  granted,
  denied,
  notAsked,
}
