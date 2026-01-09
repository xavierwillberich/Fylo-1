import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  ThemeMode _themeMode = ThemeMode.light;
  String _accentColor = 'indigo';
  double _fontSize = 16.0;
  bool _compactMode = false;
  bool _showAvatars = true;
  bool _animationsEnabled = true;

  final Map<String, Color> _accentColors = {
    'indigo': const Color(0xFF6366F1),
    'purple': const Color(0xFF8B5CF6),
    'pink': const Color(0xFFEC4899),
    'blue': const Color(0xFF3B82F6),
    'green': const Color(0xFF10B981),
    'orange': const Color(0xFFF59E0B),
    'red': const Color(0xFFEF4444),
    'teal': const Color(0xFF06B6D4),
  };

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
          'Appearance',
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
            title: 'Theme',
            children: [
              _buildThemeOption(
                icon: LucideIcons.sun,
                title: 'Light',
                subtitle: 'Bright and clear',
                isSelected: _themeMode == ThemeMode.light,
                onTap: () {
                  setState(() => _themeMode = ThemeMode.light);
                  _showSnackBar('Light theme selected');
                },
              ),
              const Divider(height: 1),
              _buildThemeOption(
                icon: LucideIcons.moon,
                title: 'Dark',
                subtitle: 'Easy on the eyes',
                isSelected: _themeMode == ThemeMode.dark,
                onTap: () {
                  setState(() => _themeMode = ThemeMode.dark);
                  _showSnackBar('Dark theme selected');
                },
              ),
              const Divider(height: 1),
              _buildThemeOption(
                icon: LucideIcons.monitor,
                title: 'System',
                subtitle: 'Match device settings',
                isSelected: _themeMode == ThemeMode.system,
                onTap: () {
                  setState(() => _themeMode = ThemeMode.system);
                  _showSnackBar('System theme selected');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Accent Color',
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose your accent color',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _accentColors.entries.map((entry) {
                        return _buildColorOption(
                          color: entry.value,
                          name: entry.key,
                          isSelected: _accentColor == entry.key,
                          onTap: () {
                            setState(() => _accentColor = entry.key);
                            _showSnackBar('${entry.key.capitalize()} accent color selected');
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Text Size',
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Font Size',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          '${_fontSize.toInt()}px',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('A', style: TextStyle(fontSize: 12)),
                        Expanded(
                          child: Slider(
                            value: _fontSize,
                            min: 12.0,
                            max: 20.0,
                            divisions: 8,
                            activeColor: const Color(0xFF6366F1),
                            onChanged: (value) {
                              setState(() => _fontSize = value);
                            },
                            onChangeEnd: (value) {
                              _showSnackBar('Font size set to ${value.toInt()}px');
                            },
                          ),
                        ),
                        const Text('A', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preview: This is how your text will look',
                      style: TextStyle(
                        fontSize: _fontSize,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Display Options',
            children: [
              _buildSwitchTile(
                icon: LucideIcons.minimize2,
                iconColor: const Color(0xFF6366F1),
                iconBgColor: const Color(0xFF6366F1).withOpacity(0.1),
                title: 'Compact Mode',
                subtitle: 'Show more content on screen',
                value: _compactMode,
                onChanged: (value) {
                  setState(() => _compactMode = value);
                  _showSnackBar('Compact mode ${value ? "enabled" : "disabled"}');
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.user,
                iconColor: const Color(0xFF10B981),
                iconBgColor: const Color(0xFF10B981).withOpacity(0.1),
                title: 'Show Avatars',
                subtitle: 'Display profile pictures',
                value: _showAvatars,
                onChanged: (value) {
                  setState(() => _showAvatars = value);
                  _showSnackBar('Avatars ${value ? "shown" : "hidden"}');
                },
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: LucideIcons.zap,
                iconColor: const Color(0xFFF59E0B),
                iconBgColor: const Color(0xFFF59E0B).withOpacity(0.1),
                title: 'Animations',
                subtitle: 'Enable smooth transitions',
                value: _animationsEnabled,
                onChanged: (value) {
                  setState(() => _animationsEnabled = value);
                  _showSnackBar('Animations ${value ? "enabled" : "disabled"}');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showSnackBar('Appearance settings saved');
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Changes',
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
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
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

  Widget _buildThemeOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
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
                color: isSelected
                    ? const Color(0xFF6366F1).withOpacity(0.1)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF6B7280),
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
            if (isSelected)
              const Icon(
                LucideIcons.checkCircle,
                size: 24,
                color: Color(0xFF6366F1),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption({
    required Color color,
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: isSelected
            ? const Icon(
                LucideIcons.check,
                color: Colors.white,
                size: 24,
              )
            : null,
      ),
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
            activeColor: const Color(0xFF6366F1),
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
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
