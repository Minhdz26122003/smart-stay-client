import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_text_field.dart';

class LandlordCreateContractScreen extends StatefulWidget {
  const LandlordCreateContractScreen({super.key});
  @override
  State<LandlordCreateContractScreen> createState() =>
      _LandlordCreateContractScreenState();
}

class _LandlordCreateContractScreenState
    extends State<LandlordCreateContractScreen> {
  final _nameCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _depositCtrl = TextEditingController(text: '5.000.000');
  final _rentCtrl = TextEditingController(text: '4.250.000');
  final _formKey = GlobalKey<FormState>();
  String _selectedRoom = 'Phòng 205 - Tầng 2 - Khu A';
  DateTime _startDate = DateTime.now();
  int _duration = 12;
  int _people = 1;

  @override
  void dispose() {
    for (final c in [_nameCtrl, _idCtrl, _phoneCtrl, _emailCtrl, _depositCtrl, _rentCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme,
        ),
        child: child!,
      ),
    );
    if (d != null) setState(() => _startDate = d);
  }

  DateTime get _endDate =>
      DateTime(_startDate.year, _startDate.month + _duration, _startDate.day);

  String _fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

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
        title: Text('Tạo hợp đồng',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Step 1 – Phòng
              _StepCard(
                step: 1,
                title: 'Thông tin phòng',
                icon: Icons.door_front_door_rounded,
                cs: cs,
                theme: theme,
                child: Column(children: [
                  // Room dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedRoom,
                        isExpanded: true,
                        icon: Icon(Icons.expand_more_rounded, color: cs.primary),
                        style: TextStyle(fontSize: 14, color: cs.onSurface),
                        items: [
                          'Phòng 205 - Tầng 2 - Khu A',
                          'Phòng 303 - Tầng 3 - Khu A',
                          'Phòng 102 - Tầng 1 - Khu A',
                        ]
                            .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedRoom = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // People counter
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(children: [
                      Icon(Icons.people_outline, color: cs.primary, size: 18),
                      const SizedBox(width: 10),
                      Text('Số người ở',
                          style: TextStyle(
                              fontSize: 13, color: cs.onSurface.withValues(alpha: 0.7))),
                      const Spacer(),
                      _CounterButton(
                        onTap: () => setState(() => _people = (_people - 1).clamp(1, 5)),
                        icon: Icons.remove,
                        cs: cs,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('$_people',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: cs.primary)),
                      ),
                      _CounterButton(
                        onTap: () => setState(() => _people = (_people + 1).clamp(1, 5)),
                        icon: Icons.add,
                        cs: cs,
                      ),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 14),

              // Step 2 – Người thuê
              _StepCard(
                step: 2,
                title: 'Thông tin người thuê',
                icon: Icons.person_outline_rounded,
                cs: cs,
                theme: theme,
                child: Column(children: [
                  AppTextField(
                    label: 'Họ và tên *',
                    hint: 'Nguyễn Văn A',
                    controller: _nameCtrl,
                    prefixIcon: Icon(Icons.person_outline, color: cs.primary),
                    validator: (v) => v!.isEmpty ? 'Bắt buộc' : null,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Số CCCD/CMND *',
                    hint: '001200012345',
                    controller: _idCtrl,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Icons.badge_outlined, color: cs.primary),
                    validator: (v) => v!.isEmpty ? 'Bắt buộc' : null,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Số điện thoại *',
                    hint: '0901234567',
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icon(Icons.phone_outlined, color: cs.primary),
                    validator: (v) => v!.isEmpty ? 'Bắt buộc' : null,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Email (tùy chọn)',
                    hint: 'email@example.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email_outlined, color: cs.primary),
                  ),
                ]),
              ),
              const SizedBox(height: 14),

              // Step 3 – Điều khoản
              _StepCard(
                step: 3,
                title: 'Điều khoản hợp đồng',
                icon: Icons.description_outlined,
                cs: cs,
                theme: theme,
                child: Column(children: [
                  // Date picker
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
                      ),
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.calendar_today_rounded,
                              size: 16, color: cs.primary),
                        ),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Ngày bắt đầu',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurface.withValues(alpha: 0.5))),
                          Text(_fmt(_startDate),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700)),
                        ]),
                        const Spacer(),
                        Text('→  ${_fmt(_endDate)}',
                            style: TextStyle(
                                fontSize: 12,
                                color: cs.onSurface.withValues(alpha: 0.5))),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Duration slider
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Icon(Icons.access_time_rounded, size: 16, color: cs.primary),
                        const SizedBox(width: 8),
                        Text('Thời hạn: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: cs.onSurface.withValues(alpha: 0.6))),
                        Text('$_duration tháng',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: cs.primary)),
                      ]),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: cs.primary,
                          thumbColor: cs.primary,
                          overlayColor: cs.primary.withValues(alpha: 0.1),
                          trackHeight: 3,
                        ),
                        child: Slider(
                          value: _duration.toDouble(),
                          min: 1,
                          max: 24,
                          divisions: 23,
                          label: '$_duration tháng',
                          onChanged: (v) => setState(() => _duration = v.toInt()),
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('1 tháng',
                            style: TextStyle(
                                fontSize: 10, color: cs.onSurface.withValues(alpha: 0.4))),
                        Text('24 tháng',
                            style: TextStyle(
                                fontSize: 10, color: cs.onSurface.withValues(alpha: 0.4))),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  // Financial fields
                  Row(children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Tiền thuê/tháng',
                        hint: '4.250.000',
                        controller: _rentCtrl,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(Icons.payments_outlined, color: cs.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        label: 'Tiền đặt cọc',
                        hint: '5.000.000',
                        controller: _depositCtrl,
                        keyboardType: TextInputType.number,
                        prefixIcon:
                            Icon(Icons.account_balance_outlined, color: cs.primary),
                      ),
                    ),
                  ]),
                ]),
              ),
              const SizedBox(height: 24),

              // Summary preview
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Tóm tắt hợp đồng',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: _SummaryItem(
                          label: 'Phòng', value: _selectedRoom.split(' - ').first),
                    ),
                    Expanded(
                      child: _SummaryItem(
                          label: 'Thời hạn', value: '$_duration tháng'),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: _SummaryItem(
                          label: 'Bắt đầu', value: _fmt(_startDate)),
                    ),
                    Expanded(
                      child: _SummaryItem(label: 'Kết thúc', value: _fmt(_endDate)),
                    ),
                  ]),
                ]),
              ),
              const SizedBox(height: 20),

              // Submit
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Hợp đồng đã được tạo thành công! 🎉'),
                      backgroundColor: cs.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ));
                    context.pop();
                  }
                },
                icon: const Icon(Icons.description_rounded,
                    color: Colors.white, size: 20),
                label: const Text('TẠO HỢP ĐỒNG',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  minimumSize: const Size(double.infinity, 54),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

class _StepCard extends StatelessWidget {
  final int step;
  final String title;
  final IconData icon;
  final ColorScheme cs;
  final ThemeData theme;
  final Widget child;

  const _StepCard({
    required this.step,
    required this.title,
    required this.icon,
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Row(children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
              child: Center(
                child: Text('$step',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, size: 18, color: cs.primary),
            const SizedBox(width: 8),
            Text(title,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          ]),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ]),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final ColorScheme cs;
  const _CounterButton(
      {required this.onTap, required this.icon, required this.cs});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: cs.primary),
        ),
      );
}

class _SummaryItem extends StatelessWidget {
  final String label, value;
  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      );
}
