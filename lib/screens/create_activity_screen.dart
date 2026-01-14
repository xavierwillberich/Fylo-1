import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../services/firebase_service.dart';
import '../core/providers/auth_provider.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({super.key});

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final TextEditingController _activityNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  DateTime _startDateTime = DateTime.now();
  DateTime _endDateTime = DateTime.now().add(const Duration(hours: 1));

  bool _requiresApproval = true;
  String _visibility = '公开';
  String _participantLimit = '不限人数';
  String _price = '免费';
  String? _selectedCoverImage;

  // P1-3 改造：从 Provider 获取当前用户 ID
  String get _currentUserId => context.read<AuthProvider>().requireUserId;

  @override
  void dispose() {
    _activityNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    LucideIcons.x,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const Text(
                  '创建活动',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: _saveActivity,
                  child: const Icon(
                    LucideIcons.check,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      _showCoverImagePicker(context);
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: _selectedCoverImage == null
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF6366F1).withOpacity(0.3),
                                  const Color(0xFF9333EA).withOpacity(0.3),
                                  const Color(0xFFEC4899).withOpacity(0.3),
                                ],
                              )
                            : null,
                        image: _selectedCoverImage != null
                            ? DecorationImage(
                                image: AssetImage(_selectedCoverImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: _selectedCoverImage == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.image,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '点击添加封面图片',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    hint: '活动名称',
                    icon: null,
                    controller: _activityNameController,
                  ),
                  const SizedBox(height: 12),
                  _buildDateTimeField(
                    label: '开始',
                    dateTime: _formatDateTime(_startDateTime, true),
                    icon: Icons.circle,
                    iconColor: Colors.white.withOpacity(0.6),
                    onTap: () => _selectDateTime(true),
                  ),
                  const SizedBox(height: 12),
                  _buildDateTimeField(
                    label: '结束',
                    dateTime: _formatDateTime(_endDateTime, false),
                    icon: Icons.circle_outlined,
                    iconColor: Colors.white.withOpacity(0.6),
                    onTap: () => _selectDateTime(false),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    hint: '选择地点',
                    icon: LucideIcons.mapPin,
                    controller: _locationController,
                    onTap: () => _showLocationPicker(),
                  ),
                  const SizedBox(height: 12),
                  _buildDescriptionField(),
                  const SizedBox(height: 24),
                  const Text(
                    '售票',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchRow(
                    icon: LucideIcons.lock,
                    label: '需要审核',
                    value: _requiresApproval,
                    onChanged: (value) {
                      setState(() {
                        _requiresApproval = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSelectionRow(
                    icon: Icons.attach_money,
                    label: '价格',
                    value: _price,
                    onTap: () => _showPricePicker(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '选项',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSelectionRow(
                    icon: LucideIcons.globe,
                    label: '可见性',
                    value: _visibility,
                    onTap: () => _showVisibilityPicker(),
                  ),
                  const SizedBox(height: 12),
                  _buildSelectionRow(
                    icon: LucideIcons.users,
                    label: '人数限制',
                    value: _participantLimit,
                    onTap: () => _showParticipantLimitPicker(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    IconData? icon,
    int maxLines = 1,
    TextEditingController? controller,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white.withOpacity(0.6), size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                enabled: onTap == null,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required String dateTime,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 16),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Text(
              dateTime,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.6), size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
            ),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF9333EA),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.6), size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(width: 8),
            Icon(
              LucideIcons.chevronRight,
              color: Colors.white.withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.alignLeft,
                color: Colors.white.withOpacity(0.6),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: '添加描述',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Spacer(),
              _buildToolbarButton(LucideIcons.search, () {}),
              const SizedBox(width: 8),
              _buildToolbarButton(LucideIcons.paperclip, () {}),
              const SizedBox(width: 8),
              _buildToolbarButton(LucideIcons.link, () {}),
              const SizedBox(width: 8),
              _buildToolbarButton(LucideIcons.moreHorizontal, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFDC2626),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime, bool includeDate) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? '下午' : '上午';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    if (includeDate) {
      return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 $period $displayHour:$minute';
    } else {
      return '$period $displayHour:$minute';
    }
  }

  Future<void> _selectDateTime(bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDateTime : _endDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF9333EA),
              surface: Color(0xFF2D2D2D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          isStart ? _startDateTime : _endDateTime,
        ),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF9333EA),
                surface: Color(0xFF2D2D2D),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStart) {
            _startDateTime = newDateTime;
            if (_startDateTime.isAfter(_endDateTime)) {
              _endDateTime = _startDateTime.add(const Duration(hours: 1));
            }
          } else {
            _endDateTime = newDateTime;
          }
        });
      }
    }
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2D2D),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '选择地点',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '搜索地点...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                  prefixIcon: Icon(
                    LucideIcons.search,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (value) {
                  _locationController.text = value;
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(
                  LucideIcons.mapPin,
                  color: Colors.white.withOpacity(0.6),
                ),
                title: const Text(
                  '使用当前位置',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _locationController.text = '当前位置';
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPricePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2D2D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '价格',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildOptionTile('免费', _price == '免费', () {
              setState(() => _price = '免费');
              Navigator.pop(context);
            }),
            _buildOptionTile('付费', _price != '免费', () {
              Navigator.pop(context);
              _showCustomPriceDialog();
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCustomPriceDialog() {
    final controller = TextEditingController();
    if (_price != '免费') {
      final priceValue = _price.replaceAll('¥', '').trim();
      controller.text = priceValue;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('设置价格', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: '输入价格',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            prefixText: '¥ ',
            prefixStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => _price = '¥${controller.text}');
                Navigator.pop(context);
              }
            },
            child: const Text('确定', style: TextStyle(color: Color(0xFF9333EA))),
          ),
        ],
      ),
    );
  }

  void _showVisibilityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2D2D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '可见性',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildOptionTile('公开', _visibility == '公开', () {
              setState(() => _visibility = '公开');
              Navigator.pop(context);
            }),
            _buildOptionTile('仅好友', _visibility == '仅好友', () {
              setState(() => _visibility = '仅好友');
              Navigator.pop(context);
            }),
            _buildOptionTile('私密', _visibility == '私密', () {
              setState(() => _visibility = '私密');
              Navigator.pop(context);
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showParticipantLimitPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2D2D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '人数限制',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildOptionTile('不限人数', _participantLimit == '不限人数', () {
              setState(() => _participantLimit = '不限人数');
              Navigator.pop(context);
            }),
            _buildOptionTile('10人', _participantLimit == '10人', () {
              setState(() => _participantLimit = '10人');
              Navigator.pop(context);
            }),
            _buildOptionTile('20人', _participantLimit == '20人', () {
              setState(() => _participantLimit = '20人');
              Navigator.pop(context);
            }),
            _buildOptionTile('50人', _participantLimit == '50人', () {
              setState(() => _participantLimit = '50人');
              Navigator.pop(context);
            }),
            _buildOptionTile('100人', _participantLimit == '100人', () {
              setState(() => _participantLimit = '100人');
              Navigator.pop(context);
            }),
            _buildOptionTile('自定义', _participantLimit.contains('自定义'), () {
              Navigator.pop(context);
              _showCustomLimitDialog();
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCustomLimitDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('自定义人数', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: '输入人数',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => _participantLimit = '${controller.text}人');
                Navigator.pop(context);
              }
            },
            child: const Text('确定', style: TextStyle(color: Color(0xFF9333EA))),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(String title, bool isSelected, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF9333EA) : Colors.white,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(LucideIcons.check, color: Color(0xFF9333EA))
          : null,
      onTap: onTap,
    );
  }

  void _showCoverImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.x),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    '添加封面图片',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.search),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip('推荐', true),
                        _buildCategoryChip('新年', false),
                        _buildCategoryChip('春节', false),
                        _buildCategoryChip('科技', false),
                        _buildCategoryChip('商务', false),
                        _buildCategoryChip('派对', false),
                        _buildCategoryChip('加密货币', false),
                        _buildCategoryChip('狂欢节', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      _buildImageCard(
                        'assets/images/Board Games.jpg',
                        '桌游',
                        'Board Games',
                        () =>
                            _selectCoverImage('assets/images/Board Games.jpg'),
                      ),
                      _buildImageCard(
                        'assets/images/Coffee Chat.jpg',
                        '咖啡聊天',
                        'Coffee Chat',
                        () =>
                            _selectCoverImage('assets/images/Coffee Chat.jpg'),
                      ),
                      _buildImageCard(
                        'assets/images/Gym.jpg',
                        '健身',
                        'Gym',
                        () => _selectCoverImage('assets/images/Gym.jpg'),
                      ),
                      _buildImageCard(
                        'assets/images/KTV.jpg',
                        'KTV',
                        'KTV',
                        () => _selectCoverImage('assets/images/KTV.jpg'),
                      ),
                      _buildImageCard(
                        'assets/images/hiking.jpg',
                        '徒步',
                        'Hiking',
                        () => _selectCoverImage('assets/images/hiking.jpg'),
                      ),
                      _buildImageCard(
                        'assets/images/Potluck.jpg',
                        '聚餐',
                        'Potluck',
                        () => _selectCoverImage('assets/images/Potluck.jpg'),
                      ),
                      _buildImageCard(
                        'assets/images/Others.jpg',
                        '其他',
                        'Others',
                        () => _selectCoverImage('assets/images/Others.jpg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '从相册选择',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveActivity() async {
    print('_saveActivity called');
    print('Activity name: ${_activityNameController.text}');

    if (_activityNameController.text.isEmpty) {
      print('Activity name is empty, showing error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入活动名称'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    try {
      print('Creating event object...');
      final event = Event(
        id: DateTime.now().millisecondsSinceEpoch,
        date: _startDateTime.day.toString(),
        month: _getMonthName(_startDateTime.month),
        year: _startDateTime.year.toString(),
        dayOfWeek: _getDayOfWeek(_startDateTime),
        weather: Weather.clear,
        temperature: 20,
        category: 'Activity',
        title: _activityNameController.text,
        description: _descriptionController.text,
        time:
            '${_startDateTime.hour}:${_startDateTime.minute.toString().padLeft(2, '0')}',
        location: _locationController.text,
        participants: 1,
        budget: _parseBudget(_price),
        recruiting: true,
        proficiency: ProficiencyLevel.beginner,
        genderRestriction: GenderRestriction.noRestrictions,
        passwordRequired: false,
        images: _selectedCoverImage != null ? [_selectedCoverImage!] : [],
        attendeeAvatars: [],
        isUserParticipating: true,
        creatorId: _currentUserId,
        participantIds: [_currentUserId],
      );

      print('Saving event to Firebase...');
      await _firebaseService.addEvent(event);
      print('Event saved successfully');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('活动创建成功'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e, stackTrace) {
      print('Error saving activity: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('创建失败: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _getDayOfWeek(DateTime dateTime) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[dateTime.weekday - 1];
  }

  int _parseBudget(String price) {
    if (price == '免费') return 0;
    final match = RegExp(r'\d+').firstMatch(price);
    return match != null ? int.parse(match.group(0)!) : 0;
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            const Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(LucideIcons.sparkles, size: 14, color: Colors.white),
            ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _selectCoverImage(String imageUrl) {
    setState(() {
      _selectedCoverImage = imageUrl;
    });
    Navigator.pop(context);
  }

  Widget _buildImageCard(
    String imageUrl,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
