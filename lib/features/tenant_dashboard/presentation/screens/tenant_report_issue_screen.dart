import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TenantReportIssueScreen extends StatefulWidget {
  const TenantReportIssueScreen({super.key});
  @override
  State<TenantReportIssueScreen> createState() =>
      _TenantReportIssueScreenState();
}

class _TenantReportIssueScreenState extends State<TenantReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();

  String _category = 'Điện';
  String _location = 'Phòng 205 – Phòng tắm';
  String _priority = 'Khẩn cấp';
  final Set<String> _selectedSlots = {'Chiều (13-17h)'};
  int _photoCount = 2;

  static const _categories = [
    _Cat('Điện', Icons.electrical_services_rounded, Color(0xFF1A8A5A)),
    _Cat('Nước', Icons.water_drop_rounded, Color(0xFF1A8A5A)),
    _Cat('Điều hòa', Icons.ac_unit_rounded, Color(0xFF1A8A5A)),
    _Cat('Cửa / Khóa', Icons.lock_rounded, Color(0xFF1A8A5A)),
    _Cat('Thiết bị', Icons.devices_rounded, Color(0xFF1A8A5A)),
    _Cat('Kết cấu', Icons.foundation_rounded, Color(0xFF1A8A5A)),
    _Cat('Vệ sinh', Icons.cleaning_services_rounded, Color(0xFF1A8A5A)),
    _Cat('Côn trùng', Icons.bug_report_rounded, Color(0xFF1A8A5A)),
    _Cat('Khác', Icons.more_horiz_rounded, Color(0xFF1A8A5A)),
  ];

  static const _locations = [
    'Phòng 205 – Phòng tắm',
    'Phòng 205 – Phòng ngủ',
    'Phòng 205 – Bếp',
    'Phòng 205 – Phòng khách',
    'Hành lang tầng 2',
    'Khu vực chung',
  ];

  static const _timeSlots = [
    'Sáng (8-12h)',
    'Chiều (13-17h)',
    'Tối (18-21h)',
    'Bất kỳ',
  ];

  static const _green = Color(0xFF1A8A5A);

  @override
  void initState() {
    super.initState();
    _descCtrl.text =
        'Vòi nước phòng tắm bị rỉ nước liên tục, '
        'không tắt được. Nước chảy cả khi đã vặn chặt.';
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
          color: _green,
        ),
        title: const Text(
          'Báo cáo sự cố',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vui lòng cung cấp chi tiết sự cố để chúng tôi hỗ\ntrợ bạn nhanh nhất.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // ── Chọn danh mục
              _SectionLabel('Chọn danh mục *'),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.15,
                children: _categories.map((cat) {
                  final sel = _category == cat.label;
                  return GestureDetector(
                    onTap: () => setState(() => _category = cat.label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      decoration: BoxDecoration(
                        color: sel ? _green : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sel ? _green : Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            cat.icon,
                            size: 28,
                            color: sel ? Colors.white : Colors.grey.shade600,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: sel ? Colors.white : Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // ── Vị trí sự cố
              _SectionLabel('Vị trí sự cố *'),
              const SizedBox(height: 8),
              _DropdownField(
                value: _location,
                items: _locations,
                onChanged: (v) => setState(() => _location = v ?? _location),
              ),
              const SizedBox(height: 24),

              // ── Mô tả vấn đề
              _SectionLabel('Mô tả vấn đề *'),
              const SizedBox(height: 8),
              Stack(
                children: [
                  TextFormField(
                    controller: _descCtrl,
                    maxLines: 5,
                    maxLength: 500,
                    validator: (v) =>
                        v!.trim().isEmpty ? 'Vui lòng mô tả sự cố' : null,
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Mô tả chi tiết sự cố...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _green),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 12,
                    child: Text(
                      '${_descCtrl.text.length}/500',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Thêm ảnh/video
              Row(
                children: [
                  const Icon(
                    Icons.photo_camera_outlined,
                    size: 17,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Thêm ảnh/video (tối đa 5)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 88,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Uploaded photos
                    ...List.generate(_photoCount, (i) {
                      return GestureDetector(
                        onTap: () => setState(() => _photoCount--),
                        child: Container(
                          width: 84,
                          height: 84,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.image_rounded,
                                  size: 36,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    // Add button
                    if (_photoCount < 5)
                      GestureDetector(
                        onTap: () => setState(() => _photoCount++),
                        child: Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 28,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Mức độ ưu tiên
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 17,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Mức độ ưu tiên',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _PriorityCard(
                label: 'Khẩn cấp',
                subtitle: 'Ảnh hưởng sinh hoạt, cần xử lý ngay',
                icon: Icons.priority_high_rounded,
                color: Colors.red.shade600,
                selected: _priority == 'Khẩn cấp',
                onTap: () => setState(() => _priority = 'Khẩn cấp'),
              ),
              const SizedBox(height: 8),
              _PriorityCard(
                label: 'Bình thường',
                subtitle: 'Có thể chờ, xử lý trong 2-3 ngày',
                icon: Icons.schedule_rounded,
                color: Colors.orange.shade600,
                selected: _priority == 'Bình thường',
                onTap: () => setState(() => _priority = 'Bình thường'),
              ),
              const SizedBox(height: 24),

              // ── Thời gian thuận tiện
              Row(
                children: [
                  const Icon(
                    Icons.access_alarm_rounded,
                    size: 17,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Thời gian thuận tiện để sửa chữa',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3.5,
                children: _timeSlots.map((slot) {
                  final sel = _selectedSlots.contains(slot);
                  return GestureDetector(
                    onTap: () => setState(
                      () => sel
                          ? _selectedSlots.remove(slot)
                          : _selectedSlots.add(slot),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      decoration: BoxDecoration(
                        color: sel ? _green : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: sel ? _green : Colors.grey.shade200,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        slot,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: sel ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // ── Submit
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Đã gửi báo cáo! Chủ nhà sẽ phản hồi sớm.',
                          ),
                          backgroundColor: _green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                      context.pop();
                    }
                  },
                  icon: const Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Gửi báo cáo sự cố',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Chủ nhà sẽ nhận thông báo ngay lập tức',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section label
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
  );
}

// ─── Dropdown
class _DropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.grey.shade600,
        ),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        onChanged: onChanged,
        items: items
            .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
            .toList(),
      ),
    ),
  );
}

// ─── Priority card
class _PriorityCard extends StatelessWidget {
  final String label, subtitle;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _PriorityCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? color : Colors.grey.shade200,
          width: selected ? 1.8 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          if (selected)
            Icon(Icons.check_circle_rounded, color: color, size: 22),
        ],
      ),
    ),
  );
}

// ─── Data class
class _Cat {
  final String label;
  final IconData icon;
  final Color color;
  const _Cat(this.label, this.icon, this.color);
}
