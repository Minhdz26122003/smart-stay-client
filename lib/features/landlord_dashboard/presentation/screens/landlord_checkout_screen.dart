import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandlordCheckoutScreen extends StatefulWidget {
  const LandlordCheckoutScreen({super.key});
  @override
  State<LandlordCheckoutScreen> createState() => _LandlordCheckoutScreenState();
}

class _LandlordCheckoutScreenState extends State<LandlordCheckoutScreen> {
  final _noteCtrl = TextEditingController();
  bool _deductDeposit = false;
  double _deductAmount = 0;
  final List<bool> _checks = [true, true, true, false, true];

  static const _checkItems = [
    'Khóa chính đã trả',
    'Thẻ xe gửi đã trả',
    'Điều hòa hoạt động bình thường',
    'Không có tổn thất tài sản',
    'Đã vệ sinh phòng',
  ];

  static const int _deposit = 8500000;

  String _formatCurrency(int amount) {
    final s = amount.toString();
    final result = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return result.toString();
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final refund = _deposit - _deductAmount.toInt();
    final checkedCount = _checks.where((c) => c).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: cs.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Thủ tục trả phòng',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tenant + Room header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.error, cs.error.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Trả phòng',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                    const Text('Phòng 205 - Nguyễn Thị Linh',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('01/03/2025 → 01/04/2026 · 13 tháng',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.7))),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // Checklist
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  child: Row(children: [
                    Icon(Icons.checklist_rounded, color: cs.primary, size: 18),
                    const SizedBox(width: 8),
                    Text('Checklist bàn giao',
                        style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (checkedCount == _checks.length
                                ? Colors.green
                                : Colors.orange)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$checkedCount/${_checks.length}',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: checkedCount == _checks.length
                                ? Colors.green
                                : Colors.orange),
                      ),
                    ),
                  ]),
                ),
                const Divider(height: 1),
                ...List.generate(_checkItems.length, (i) {
                  return CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    value: _checks[i],
                    activeColor: cs.primary,
                    title: Text(
                      _checkItems[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _checks[i] ? cs.onSurface : cs.onSurface.withValues(alpha: 0.5),
                        decoration: _checks[i] ? null : TextDecoration.lineThrough,
                      ),
                    ),
                    secondary: Icon(
                      _checks[i] ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: _checks[i] ? Colors.green : cs.onSurface.withValues(alpha: 0.2),
                      size: 18,
                    ),
                    onChanged: (v) => setState(() => _checks[i] = v!),
                  );
                }),
                const SizedBox(height: 8),
              ]),
            ),
            const SizedBox(height: 14),

            // Deposit return
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.account_balance_wallet_rounded, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                  Text('Hoàn tiền cọc',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 16),
                _InfoRow('Tiền đặt cọc gốc', '${_formatCurrency(_deposit)} đ', cs),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Khấu trừ thiệt hại',
                      style: TextStyle(
                          fontSize: 13,
                          color: cs.onSurface.withValues(alpha: 0.65))),
                  Switch(
                    value: _deductDeposit,
                    activeColor: cs.error,
                    onChanged: (v) => setState(() {
                      _deductDeposit = v;
                      _deductAmount = v ? 500000 : 0;
                    }),
                  ),
                ]),
                if (_deductDeposit) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cs.error.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cs.error.withValues(alpha: 0.2)),
                    ),
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Số tiền khấu trừ',
                            style: TextStyle(fontSize: 12, color: cs.error)),
                        Text(
                          '- ${_formatCurrency(_deductAmount.toInt())} đ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700, color: cs.error),
                        ),
                      ]),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: cs.error,
                          thumbColor: cs.error,
                          overlayColor: cs.error.withValues(alpha: 0.1),
                          trackHeight: 3,
                        ),
                        child: Slider(
                          value: _deductAmount,
                          min: 0,
                          max: _deposit.toDouble(),
                          divisions: 100,
                          onChanged: (v) => setState(() => _deductAmount = v),
                        ),
                      ),
                    ]),
                  ),
                ],
                const Divider(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Hoàn trả cho người thuê',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700)),
                  Text(
                    '${_formatCurrency(refund)} đ',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800, color: cs.primary),
                  ),
                ]),
              ]),
            ),
            const SizedBox(height: 14),

            // Note
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.edit_note_rounded, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                  Text('Ghi chú bàn giao',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 12),
                TextField(
                  controller: _noteCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Ghi chú thêm về tình trạng phòng khi bàn giao...',
                    hintStyle: TextStyle(
                        fontSize: 13, color: cs.onSurface.withValues(alpha: 0.4)),
                    filled: true,
                    fillColor: const Color(0xFFF8F9FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 24),

            // Confirm button
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text('Xác nhận trả phòng'),
                    content: Text(
                        'Hành động này không thể hoàn tác.\nHoàn trả: ${_formatCurrency(refund)} đ cho Nguyễn Thị Linh.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Hủy'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Đã hoàn tất thủ tục trả phòng!'),
                            backgroundColor: cs.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ));
                          context.go('/landlord');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.error,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Xác nhận'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
              label: const Text('XÁC NHẬN TRẢ PHÒNG',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.error,
                minimumSize: const Size(double.infinity, 54),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final ColorScheme cs;
  const _InfoRow(this.label, this.value, this.cs);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.55))),
          Text(value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurface)),
        ],
      );
}
