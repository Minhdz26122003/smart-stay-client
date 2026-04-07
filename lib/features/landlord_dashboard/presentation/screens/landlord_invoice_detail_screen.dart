import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../invoice/domain/entities/invoice.dart';

String _formatVnd(double amount) {
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  return formatter.format(amount);
}

class LandlordInvoiceDetailScreen extends StatelessWidget {
  final Invoice? invoice;
  const LandlordInvoiceDetailScreen({super.key, this.invoice});

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
          'Chi tiết hóa đơn',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: cs.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card with gradient
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.primary, cs.primary.withValues(alpha: 0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    invoice?.periodLabel ?? 'Hóa đơn dịch vụ',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Chi tiết thanh toán', // Assuming we don't have the roomName passing down yet here
                    style: TextStyle(
                      color: Color.from(alpha: 1, red: 1, green: 1, blue: 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Total amount
                  Text(
                    invoice != null ? _formatVnd(invoice!.totalAmount) : '4.705.000 đ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: invoice?.isPaid == true ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: invoice?.isPaid == true ? Colors.green.shade400 : Colors.orange.shade400),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          invoice?.isPaid == true ? Icons.check_circle_rounded : Icons.schedule_rounded,
                          color: invoice?.isPaid == true ? Colors.green.shade300 : Colors.orange.shade300,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          invoice?.status.displayName ?? 'Chưa thanh toán · Hạn 25/04',
                          style: TextStyle(
                            color: invoice?.isPaid == true ? Colors.green.shade200 : Colors.orange.shade200,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.notifications_rounded,
                    label: 'Nhắc nhở',
                    color: Colors.orange,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Đã gửi nhắc nhở thanh toán!'),
                        backgroundColor: cs.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.check_circle_rounded,
                    label: 'Đã thu',
                    color: Colors.green,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Đã cập nhật trạng thái thanh toán!',
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.chat_bubble_rounded,
                    label: 'Nhắn tin',
                    color: cs.primary,
                    onTap: () => context.push('/landlord/chat'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cost breakdown
            Container(
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
                        Icon(
                          Icons.receipt_outlined,
                          size: 18,
                          color: cs.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Chi tiết thanh toán',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _CostRow(
                          icon: Icons.home_outlined,
                          label: 'Tiền phòng',
                          value: invoice?.breakdown != null ? _formatVnd(invoice!.breakdown!.rent) : '4.250.000 đ',
                          cs: cs,
                        ),
                        const SizedBox(height: 12),
                        _CostRow(
                          icon: Icons.electric_bolt_rounded,
                          label: invoice?.breakdown != null ? 'Điện (${invoice!.breakdown!.electricityConsumed} kWh)' : 'Điện',
                          value: invoice?.breakdown != null ? _formatVnd(invoice!.breakdown!.electricityAmount) : '199.500 đ',
                          cs: cs,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 12),
                        _CostRow(
                          icon: Icons.water_drop_rounded,
                          label: invoice?.breakdown != null ? 'Nước (${invoice!.breakdown!.waterConsumed} khối)' : 'Nước',
                          value: invoice?.breakdown != null ? _formatVnd(invoice!.breakdown!.waterAmount) : '60.000 đ',
                          cs: cs,
                          color: Colors.blue,
                        ),
                        if (invoice?.breakdown != null && invoice!.breakdown!.internet > 0) ...[
                          const SizedBox(height: 12),
                          _CostRow(
                            icon: Icons.wifi_rounded,
                            label: 'Phí Wifi',
                            value: _formatVnd(invoice!.breakdown!.internet),
                            cs: cs,
                          ),
                        ],
                        if (invoice?.breakdown != null && invoice!.breakdown!.garbage > 0) ...[
                          const SizedBox(height: 12),
                          _CostRow(
                            icon: Icons.delete_outline_rounded,
                            label: 'Phí rác',
                            value: _formatVnd(invoice!.breakdown!.garbage),
                            cs: cs,
                          ),
                        ],
                        const Divider(height: 24),
                        // Wavy total row
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tổng cộng',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                ),
                              ),
                              Text(
                                invoice != null ? _formatVnd(invoice!.totalAmount) : '4.609.500 đ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: cs.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Meta info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _MetaRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Kỳ thanh toán',
                    value: invoice?.periodLabel ?? '1',
                    cs: cs,
                  ),
                  const SizedBox(height: 12),
                  _MetaRow(
                    icon: Icons.event_available_rounded,
                    label: 'Hạn thanh toán',
                    value: 'N/A', // TODO: invoice model does not have a dueDate field yet
                    cs: cs,
                    isAlert: invoice?.isPaid == false,
                  ),
                  const SizedBox(height: 12),
                  _MetaRow(
                    icon: Icons.access_time_rounded,
                    label: 'Tháng',
                    value: invoice != null ? '${invoice!.month}/${invoice!.year}' : '',
                    cs: cs,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Payment QR / Copy bank
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.qr_code_2_rounded,
                        size: 18,
                        color: cs.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Thông tin chuyển khoản',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _BankInfoRow(
                    label: 'Ngân hàng',
                    value: 'Vietcombank',
                    cs: cs,
                  ),
                  const SizedBox(height: 8),
                  _BankInfoRow(
                    label: 'Số tài khoản',
                    value: '1234 5678 90',
                    cs: cs,
                    copyable: true,
                  ),
                  const SizedBox(height: 8),
                  _BankInfoRow(
                    label: 'Tên TK',
                    value: 'NGUYEN VAN HUNG',
                    cs: cs,
                  ),
                  const SizedBox(height: 8),
                  _BankInfoRow(
                    label: 'Nội dung',
                    value: 'Phong 205 T4 2026',
                    cs: cs,
                    copyable: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}

class _CostRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final ColorScheme cs;
  final Color? color;

  const _CostRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
    this.color,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: (color ?? cs.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: color ?? cs.primary),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: cs.onSurface.withValues(alpha: 0.65),
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
      ),
    ],
  );
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final ColorScheme cs;
  final bool isAlert;

  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: isAlert ? Colors.orange : cs.primary),
      const SizedBox(width: 10),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: cs.onSurface.withValues(alpha: 0.55),
        ),
      ),
      const Spacer(),
      Text(
        value,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isAlert ? Colors.orange : cs.onSurface,
        ),
      ),
    ],
  );
}

class _BankInfoRow extends StatelessWidget {
  final String label, value;
  final ColorScheme cs;
  final bool copyable;

  const _BankInfoRow({
    required this.label,
    required this.value,
    required this.cs,
    this.copyable = false,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 110,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      if (copyable)
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã copy: $value'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Icon(Icons.copy_rounded, size: 16, color: cs.primary),
        ),
    ],
  );
}
