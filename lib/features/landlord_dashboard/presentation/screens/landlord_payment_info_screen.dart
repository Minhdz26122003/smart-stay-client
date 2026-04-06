import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class LandlordPaymentInfoScreen extends StatefulWidget {
  const LandlordPaymentInfoScreen({super.key});
  @override
  State<LandlordPaymentInfoScreen> createState() =>
      _LandlordPaymentInfoScreenState();
}

class _LandlordPaymentInfoScreenState extends State<LandlordPaymentInfoScreen> {
  bool _editing = false;
  final _bankCtrl = TextEditingController(text: 'Vietcombank');
  final _accountCtrl = TextEditingController(text: '1234567890');
  final _nameCtrl = TextEditingController(text: 'NGUYEN VAN HUNG');

  @override
  void dispose() {
    for (final c in [_bankCtrl, _accountCtrl, _nameCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Đã copy: $text'),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 1),
    ));
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
        title: Text('Thông tin nhận tiền',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: () => setState(() => _editing = !_editing),
            child: Text(
              _editing ? 'Lưu' : 'Chỉnh sửa',
              style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // QR Code card
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(children: [
                // QR display
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: cs.primary.withValues(alpha: 0.15), width: 2),
                  ),
                  child: Stack(alignment: Alignment.center, children: [
                    Icon(Icons.qr_code_2_rounded,
                        size: 160,
                        color: cs.onSurface.withValues(alpha: 0.2)),
                    // Center logo
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
                      ),
                      child: Icon(Icons.home_rounded, color: cs.primary, size: 22),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
                Text('Mã QR thanh toán',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                Text('Scan để chuyển tiền nhanh',
                    style: TextStyle(
                        fontSize: 12, color: cs.onSurface.withValues(alpha: 0.5))),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Tải QR'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share_rounded, size: 16, color: Colors.white),
                    label: const Text('Chia sẻ',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ]),
              ]),
            ),
            const SizedBox(height: 16),

            // Bank info card
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                  child: Row(children: [
                    Icon(Icons.account_balance_rounded, size: 18, color: cs.primary),
                    const SizedBox(width: 8),
                    Text('Tài khoản ngân hàng',
                        style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700)),
                  ]),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _editing
                      ? Column(children: [
                          _EditField(
                            label: 'Ngân hàng',
                            controller: _bankCtrl,
                            icon: Icons.account_balance_outlined,
                            cs: cs,
                          ),
                          const SizedBox(height: 12),
                          _EditField(
                            label: 'Số tài khoản',
                            controller: _accountCtrl,
                            icon: Icons.credit_card_rounded,
                            keyboard: TextInputType.number,
                            cs: cs,
                          ),
                          const SizedBox(height: 12),
                          _EditField(
                            label: 'Tên chủ tài khoản (IN HOA)',
                            controller: _nameCtrl,
                            icon: Icons.person_outline_rounded,
                            cs: cs,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => setState(() => _editing = false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Lưu thay đổi',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ])
                      : Column(children: [
                          _BankInfoTile(
                            icon: Icons.account_balance_outlined,
                            label: 'Ngân hàng',
                            value: _bankCtrl.text,
                            cs: cs,
                            theme: theme,
                          ),
                          const Divider(height: 20),
                          _BankInfoTile(
                            icon: Icons.credit_card_rounded,
                            label: 'Số tài khoản',
                            value: _accountCtrl.text,
                            cs: cs,
                            theme: theme,
                            onCopy: () => _copyToClipboard(context, _accountCtrl.text),
                          ),
                          const Divider(height: 20),
                          _BankInfoTile(
                            icon: Icons.person_outline_rounded,
                            label: 'Chủ tài khoản',
                            value: _nameCtrl.text,
                            cs: cs,
                            theme: theme,
                          ),
                        ]),
                ),
              ]),
            ),
            const SizedBox(height: 14),

            // Info banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
              ),
              child: Row(children: [
                Icon(Icons.info_outline_rounded, color: cs.primary, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Người thuê sẽ thấy thông tin này khi thanh toán hóa đơn. Đảm bảo thông tin chính xác.',
                    style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.7),
                        height: 1.5),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final ColorScheme cs;
  final TextInputType keyboard;

  const _EditField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.cs,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboard,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 18, color: cs.primary),
              filled: true,
              fillColor: const Color(0xFFF8F9FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ],
      );
}

class _BankInfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final ColorScheme cs;
  final ThemeData theme;
  final VoidCallback? onCopy;

  const _BankInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
    required this.theme,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: cs.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11, color: cs.onSurface.withValues(alpha: 0.5))),
            Text(value,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ]),
        ),
        if (onCopy != null)
          GestureDetector(
            onTap: onCopy,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.copy_rounded, size: 16, color: cs.primary),
            ),
          ),
      ]);
}
