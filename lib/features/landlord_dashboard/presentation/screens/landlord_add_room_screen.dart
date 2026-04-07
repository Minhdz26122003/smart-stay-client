import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_text_field.dart';

class LandlordAddRoomScreen extends StatefulWidget {
  const LandlordAddRoomScreen({super.key});

  @override
  State<LandlordAddRoomScreen> createState() => _LandlordAddRoomScreenState();
}

class _LandlordAddRoomScreenState extends State<LandlordAddRoomScreen> {
  final _nameCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _occupantsCtrl = TextEditingController(text: '2');
  final _formKey = GlobalKey<FormState>();
  String _roomType = 'Standard';

  static const _roomTypes = ['Standard', 'VIP', 'Studio', 'Dorm'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _areaCtrl.dispose();
    _priceCtrl.dispose();
    _occupantsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: const Text('Thêm phòng mới'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loại phòng',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _roomTypes.map((type) {
                        final isSelected = _roomType == type;
                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _roomType = type);
                          },
                          selectedColor: cs.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : cs.onSurface,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      label: 'Tên phòng *',
                      hint: 'Ví dụ: P.101',
                      controller: _nameCtrl,
                      validator: (v) => v!.isEmpty ? 'Vui lòng nhập tên phòng' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Giá thuê (VNĐ)',
                            hint: '2,500,000',
                            keyboardType: TextInputType.number,
                            controller: _priceCtrl,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppTextField(
                            label: 'Diện tích (m²)',
                            hint: '20',
                            keyboardType: TextInputType.number,
                            controller: _areaCtrl,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Số khách tối đa',
                      hint: '2',
                      keyboardType: TextInputType.number,
                      controller: _occupantsCtrl,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Call API POST /api/v1/rooms via Cubit
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Đã tạo phòng thành công!'),
                        backgroundColor: cs.primary,
                      ),
                    );
                    context.pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.add_home_work_rounded),
                label: const Text('Thêm mới', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
