import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../property/presentation/cubit/property_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../property/presentation/cubit/property_cubit.dart';
import '../../../listing/presentation/cubit/listing_cubit.dart';
import '../../../room/domain/entities/room.dart';

class LandlordPostRoomScreen extends StatefulWidget {
  final Room? room;
  const LandlordPostRoomScreen({super.key, this.room});
  @override
  State<LandlordPostRoomScreen> createState() => _LandlordPostRoomScreenState();
}

class _LandlordPostRoomScreenState extends State<LandlordPostRoomScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _rentCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Set<String> _amenities = {};
  int _photoCount = 0;
  String _roomType = 'Phòng trọ';

  static const _allAmenities = [
    ('Điều hòa', Icons.ac_unit_rounded),
    ('Bãi giữ xe', Icons.motorcycle_rounded),
    ('Wifi', Icons.wifi_rounded),
    ('Bếp riêng', Icons.kitchen_rounded),
    ('WC riêng', Icons.bathroom_rounded),
    ('Máy giặt', Icons.local_laundry_service_rounded),
    ('Nóng lạnh', Icons.water_rounded),
    ('Ban công', Icons.balcony_rounded),
    ('Cửa sổ', Icons.window_rounded),
    ('Tủ lạnh', Icons.kitchen_rounded),
  ];

  static const _roomTypes = [
    'Phòng trọ',
    'Phòng nguyên căn',
    'Studio',
    'Chung cư mini',
  ];

  @override
  void dispose() {
    for (final c in [
      _titleCtrl,
      _descCtrl,
      _rentCtrl,
      _areaCtrl,
      _addressCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: cs.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Đăng phòng cho thuê',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Photo uploader
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.photo_camera_rounded,
                            size: 18,
                            color: cs.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ảnh phòng',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$_photoCount/6',
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // Add photo button
                          GestureDetector(
                            onTap: () => setState(
                              () => _photoCount = (_photoCount + 1).clamp(0, 6),
                            ),
                            child: Container(
                              width: 110,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FF),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: cs.primary.withValues(alpha: 0.3),
                                  style: BorderStyle.solid,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 28,
                                    color: cs.primary,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Thêm ảnh',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: cs.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'tối thiểu 3',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: cs.onSurface.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Photo placeholders
                          ...List.generate(
                            _photoCount,
                            (i) => Container(
                              width: 110,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: cs.primaryContainer.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Icon(
                                      Icons.image_rounded,
                                      size: 36,
                                      color: cs.primary.withValues(alpha: 0.4),
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _photoCount--),
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (i == 0)
                                    Positioned(
                                      bottom: 6,
                                      left: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: cs.primary,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: const Text(
                                          'Ảnh bìa',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_photoCount < 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 12,
                              color: Colors.orange.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Cần thêm ${3 - _photoCount} ảnh nữa',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.orange.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Basic info card
              _FormCard(
                icon: Icons.info_outline_rounded,
                title: 'Thông tin cơ bản',
                cs: cs,
                theme: theme,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loại phòng',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withValues(alpha: 0.75),
                        letterSpacing: 0.1,
                      ),
                    ),
                    // Room type chips
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _roomTypes.map((t) {
                            final sel = t == _roomType;
                            return GestureDetector(
                              onTap: () => setState(() => _roomType = t),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: sel ? cs.primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: sel
                                        ? cs.primary
                                        : cs.outline.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: sel
                                        ? Colors.white
                                        : cs.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Tiêu đề tin đăng *',
                      hint: 'Phòng trọ đẹp có nội thất gần ĐH...',
                      controller: _titleCtrl,
                      validator: (v) => v!.isEmpty ? 'Bắt buộc' : null,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      label: 'Địa chỉ *',
                      hint: '123 Nguyễn Văn Cừ, Q.5, TP.HCM',
                      controller: _addressCtrl,
                      validator: (v) => v!.isEmpty ? 'Bắt buộc' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Giá thuê (đ/tháng) *',
                            hint: '4.250.000',
                            controller: _rentCtrl,
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Bắt buộc' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            label: 'Diện tích (m²)',
                            hint: '25',
                            controller: _areaCtrl,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mô tả phòng',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface.withValues(alpha: 0.65),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _descCtrl,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText:
                                'Mô tả vị trí, tiện nghi, điểm nổi bật...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: cs.onSurface.withValues(alpha: 0.4),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8F9FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Amenities card
              _FormCard(
                icon: Icons.star_outline_rounded,
                title: 'Tiện ích',
                cs: cs,
                theme: theme,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allAmenities.map((a) {
                    final label = a.$1;
                    final icon = a.$2;
                    final selected = _amenities.contains(label);
                    return GestureDetector(
                      onTap: () => setState(
                        () => selected
                            ? _amenities.remove(label)
                            : _amenities.add(label),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? cs.primary
                              : const Color(0xFFF8F9FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? cs.primary
                                : cs.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 14,
                              color: selected
                                  ? Colors.white
                                  : cs.onSurface.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: selected
                                    ? Colors.white
                                    : cs.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Submit
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final propState = context.read<PropertyCubit>().state;
                    String? propId;
                    propState.maybeWhen(
                      loaded: (_, selected) => propId = selected?.id,
                      orElse: () {},
                    );

                    if (propId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Lỗi: Chưa chọn nhà trọ'),
                          backgroundColor: cs.error,
                        ),
                      );
                      return;
                    }

                    await context.read<ListingCubit>().createListing(
                      propertyId: propId!,
                      roomId: widget.room?.id,
                      title: _titleCtrl.text,
                      description: _descCtrl.text,
                      price: double.tryParse(_rentCtrl.text) ?? 0.0,
                      area: double.tryParse(_areaCtrl.text) ?? 20.0,
                      facilities: _amenities.toList(),
                      photoUrls: [],
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Đã đăng tin thành công! 🎉'),
                          backgroundColor: cs.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                      context.pop();
                    }
                  }
                },
                icon: const Icon(
                  Icons.publish_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  'ĐĂNG TIN NGAY',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  minimumSize: const Size(double.infinity, 54),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final ColorScheme cs;
  final ThemeData theme;
  final Widget child;

  const _FormCard({
    required this.icon,
    required this.title,
    required this.cs,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: cs.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
