import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';

/// 任务3：权限页面接入真实 OS 权限 (permission_handler)
class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> with WidgetsBindingObserver {
  final List<PermissionItem> _permissions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializePermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 当从系统设置返回时刷新权限状态
    if (state == AppLifecycleState.resumed) {
      _refreshPermissionStatuses();
    }
  }

  Future<void> _initializePermissions() async {
    _permissions.addAll([
      PermissionItem(
        permission: Permission.locationWhenInUse,
        icon: LucideIcons.mapPin,
        iconColor: const Color(0xFFEF4444),
        iconBgColor: const Color(0xFFEF4444).withOpacity(0.1),
        title: 'Location',
        description: 'Used to find activities near you',
      ),
      PermissionItem(
        permission: Permission.camera,
        icon: LucideIcons.camera,
        iconColor: const Color(0xFF6366F1),
        iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
        title: 'Camera',
        description: 'Take photos for your profile and activities',
      ),
      PermissionItem(
        permission: Permission.photos,
        icon: LucideIcons.image,
        iconColor: const Color(0xFF8B5CF6),
        iconBgColor: const Color(0xFF8B5CF6).withOpacity(0.1),
        title: 'Photos',
        description: 'Access photos from your library',
      ),
      PermissionItem(
        permission: Permission.notification,
        icon: LucideIcons.bell,
        iconColor: const Color(0xFFF59E0B),
        iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
        title: 'Notifications',
        description: 'Receive updates about activities and messages',
      ),
      PermissionItem(
        permission: Permission.microphone,
        icon: LucideIcons.mic,
        iconColor: const Color(0xFF10B981),
        iconBgColor: const Color(0xFF10B981).withOpacity(0.1),
        title: 'Microphone',
        description: 'Record audio messages',
      ),
      PermissionItem(
        permission: Permission.contacts,
        icon: LucideIcons.users,
        iconColor: const Color(0xFF06B6D4),
        iconBgColor: const Color(0xFF06B6D4).withOpacity(0.1),
        title: 'Contacts',
        description: 'Find friends who are already on Fylo',
      ),
      PermissionItem(
        permission: Permission.calendarFullAccess,
        icon: LucideIcons.calendar,
        iconColor: const Color(0xFFEC4899),
        iconBgColor: const Color(0xFFEC4899).withOpacity(0.1),
        title: 'Calendar',
        description: 'Add activities to your calendar',
      ),
    ]);

    await _refreshPermissionStatuses();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshPermissionStatuses() async {
    if (kIsWeb) {
      // Web 平台不支持 permission_handler，显示说明页
      return;
    }
    
    for (final item in _permissions) {
      try {
        item.status = await item.permission.status;
      } catch (e) {
        // 某些权限在某些平台不可用
        item.status = PermissionStatus.denied;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _requestPermission(PermissionItem item) async {
    if (kIsWeb) {
      _showSnackBar('请在浏览器设置中管理权限');
      return;
    }

    try {
      final status = await item.permission.request();
      item.status = status;
      
      if (status.isPermanentlyDenied) {
        // 用户永久拒绝，引导去设置
        _showPermanentlyDeniedDialog(item);
      } else if (status.isGranted) {
        _showSnackBar('${item.title} 权限已授予');
      } else if (status.isDenied) {
        _showSnackBar('${item.title} 权限被拒绝');
      }
      
      setState(() {});
    } catch (e) {
      _showSnackBar('请求权限失败: $e');
    }
  }

  void _showPermanentlyDeniedDialog(PermissionItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${item.title} 权限被禁用'),
        content: Text('您已永久拒绝了${item.title}权限。请前往系统设置手动开启。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
            ),
            child: const Text('打开设置', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Web 平台显示说明页
    if (kIsWeb) {
      return _buildWebExplanationPage();
    }

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
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw, color: Color(0xFF6366F1)),
            onPressed: _refreshPermissionStatuses,
            tooltip: '刷新状态',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // 说明卡片
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
                          '点击权限项可以请求或管理该权限。权限状态实时从系统获取。',
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
                // 权限列表
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: _permissions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final permission = entry.value;
                      return Column(
                        children: [
                          _buildPermissionTile(permission),
                          if (index < _permissions.length - 1)
                            const Divider(height: 1, indent: 80),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                // 打开系统设置按钮
                _buildOpenSettingsButton(),
              ],
            ),
    );
  }

  Widget _buildWebExplanationPage() {
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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(
                  LucideIcons.globe,
                  size: 48,
                  color: Color(0xFFF59E0B),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Web 平台权限说明',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '在 Web 浏览器中，权限由浏览器直接管理。\n\n'
                  '当您使用需要权限的功能时（如相机、位置），浏览器会自动弹出权限请求。\n\n'
                  '您可以在浏览器地址栏左侧的锁图标中查看和管理网站权限。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF92400E),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 权限说明列表（只读）
          const Text(
            'Fylo 可能需要的权限：',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ..._getWebPermissionExplanations(),
        ],
      ),
    );
  }

  List<Widget> _getWebPermissionExplanations() {
    final explanations = [
      {'icon': LucideIcons.mapPin, 'title': '位置', 'desc': '用于查找附近的活动'},
      {'icon': LucideIcons.camera, 'title': '相机', 'desc': '用于拍照上传'},
      {'icon': LucideIcons.bell, 'title': '通知', 'desc': '用于接收活动提醒'},
      {'icon': LucideIcons.mic, 'title': '麦克风', 'desc': '用于录制语音消息'},
    ];

    return explanations.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(item['icon'] as IconData, color: const Color(0xFF6366F1), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['desc'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
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

    if (status.isGranted) {
      bgColor = const Color(0xFF10B981).withOpacity(0.1);
      textColor = const Color(0xFF10B981);
      text = 'Granted';
      icon = LucideIcons.checkCircle;
    } else if (status.isPermanentlyDenied) {
      bgColor = const Color(0xFFEF4444).withOpacity(0.1);
      textColor = const Color(0xFFEF4444);
      text = 'Blocked';
      icon = LucideIcons.xOctagon;
    } else if (status.isDenied) {
      bgColor = const Color(0xFFF59E0B).withOpacity(0.1);
      textColor = const Color(0xFFF59E0B);
      text = 'Denied';
      icon = LucideIcons.xCircle;
    } else if (status.isRestricted) {
      bgColor = const Color(0xFF6B7280).withOpacity(0.1);
      textColor = const Color(0xFF6B7280);
      text = 'Restricted';
      icon = LucideIcons.lock;
    } else {
      bgColor = const Color(0xFF6B7280).withOpacity(0.1);
      textColor = const Color(0xFF6B7280);
      text = 'Not Set';
      icon = LucideIcons.minusCircle;
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
    if (permission.status.isGranted) {
      // 已授权，提示去设置撤销
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
              const Text(
                '该权限已授予。如需撤销，请前往系统设置。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        openAppSettings();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '打开设置',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (permission.status.isPermanentlyDenied) {
      // 永久拒绝，引导去设置
      _showPermanentlyDeniedDialog(permission);
    } else {
      // 未授权或未请求过，请求权限
      _requestPermission(permission);
    }
  }

  Widget _buildOpenSettingsButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => openAppSettings(),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.settings, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text(
                  '打开系统设置',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

/// 权限项模型
class PermissionItem {
  final Permission permission;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String description;
  PermissionStatus status;

  PermissionItem({
    required this.permission,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.description,
    this.status = PermissionStatus.denied,
  });
}
