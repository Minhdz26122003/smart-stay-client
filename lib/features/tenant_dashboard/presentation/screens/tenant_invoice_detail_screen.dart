import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class TenantInvoiceDetailScreen extends StatelessWidget {
  const TenantInvoiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: CustomScrollView(
        slivers: [
          // Gradient header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.primary, cs.primary.withValues(alpha: 0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => context.pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Chi tiết hóa đơn',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.share_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Hóa đơn tháng 4/2026',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '4.509.500 đ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.5),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                color: Colors.red,
                                size: 14,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Chưa thanh toán · Hạn 25/04/2026',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Quick actions
                  Row(
                    children: [
                      Expanded(
                        child: _QuickBtn(
                          icon: Icons.download_rounded,
                          label: 'Tải PDF',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickBtn(
                          icon: Icons.chat_bubble_rounded,
                          label: 'Hỏi chủ nhà',
                          onTap: () => context.push('/tenant/chat'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickBtn(
                          icon: Icons.history_rounded,
                          label: 'Lịch sử',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Cost breakdown
                  _DetailCard(
                    icon: Icons.receipt_long_rounded,
                    title: 'Chi tiết chi phí',
                    cs: cs,
                    theme: theme,
                    child: Column(
                      children: [
                        _CostRow(
                          icon: Icons.home_rounded,
                          label: 'Tiền phòng',
                          value: '4.250.000 đ',
                          color: cs.primary,
                          cs: cs,
                        ),
                        const SizedBox(height: 10),
                        _CostRow(
                          icon: Icons.electric_bolt_rounded,
                          label: 'Điện',
                          subtitle: '57 kWh × 3.500đ',
                          value: '199.500 đ',
                          color: Colors.amber,
                          cs: cs,
                        ),
                        const SizedBox(height: 10),
                        _CostRow(
                          icon: Icons.water_drop_rounded,
                          label: 'Nước',
                          subtitle: '4 m³ × 15.000đ',
                          value: '60.000 đ',
                          color: Colors.blue,
                          cs: cs,
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng cộng',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '4.509.500 đ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: cs.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Meter readings
                  _DetailCard(
                    icon: Icons.speed_rounded,
                    title: 'Chỉ số đồng hồ',
                    cs: cs,
                    theme: theme,
                    child: Column(
                      children: [
                        _MeterCard(
                          icon: Icons.electric_bolt_rounded,
                          name: 'Điện',
                          prev: 1043,
                          curr: 1100,
                          unit: 'kWh',
                          color: Colors.amber,
                          cs: cs,
                        ),
                        const SizedBox(height: 12),
                        _MeterCard(
                          icon: Icons.water_drop_rounded,
                          name: 'Nước',
                          prev: 28,
                          curr: 32,
                          unit: 'm³',
                          color: Colors.blue,
                          cs: cs,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Bank payment info
                  _DetailCard(
                    icon: Icons.account_balance_rounded,
                    title: 'Thông tin chuyển khoản',
                    cs: cs,
                    theme: theme,
                    child: Column(
                      children: [
                        _BankInfoRow(
                          label: 'Ngân hàng',
                          value: 'Vietcombank',
                          cs: cs,
                        ),
                        const Divider(height: 16),
                        _BankInfoRow(
                          label: 'Số tài khoản',
                          value: '0123456789',
                          cs: cs,
                          copyable: true,
                        ),
                        const Divider(height: 16),
                        _BankInfoRow(
                          label: 'Chủ tài khoản',
                          value: 'NGUYEN VAN HUNG',
                          cs: cs,
                        ),
                        const Divider(height: 16),
                        _BankInfoRow(
                          label: 'Nội dung CK',
                          value: 'P205 T4/2026 [Tên]',
                          cs: cs,
                          copyable: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pay CTA
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Đang chuyển tới cổng thanh toán...',
                          ),
                          backgroundColor: cs.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.payment_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      'THANH TOÁN NGAY',
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
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final ColorScheme cs;
  final ThemeData theme;
  final Widget child;
  const _DetailCard({
    required this.icon,
    required this.title,
    required this.cs,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
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
        Padding(padding: const EdgeInsets.all(18), child: child),
      ],
    ),
  );
}

class _CostRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final String? subtitle;
  final Color color;
  final ColorScheme cs;
  const _CostRow({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    required this.color,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
          ],
        ),
      ),
      Text(
        value,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
    ],
  );
}

class _MeterCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final int prev, curr;
  final String unit;
  final Color color;
  final ColorScheme cs;
  const _MeterCard({
    required this.icon,
    required this.name,
    required this.prev,
    required this.curr,
    required this.unit,
    required this.color,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _MeterBox(value: '$prev', label: 'Kỳ trước', cs: cs),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: cs.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  _MeterBox(value: '$curr', label: 'Kỳ này', cs: cs),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${curr - prev} $unit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              'Sử dụng',
              style: TextStyle(
                fontSize: 10,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _MeterBox extends StatelessWidget {
  final String value, label;
  final ColorScheme cs;
  const _MeterBox({required this.value, required this.label, required this.cs});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 9,
          color: cs.onSurface.withValues(alpha: 0.45),
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
          overflow: TextOverflow.ellipsis,
        ),
      ),
      if (copyable)
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã sao chép: $value'),
                duration: const Duration(seconds: 1),
                backgroundColor: cs.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.copy_rounded, size: 16, color: cs.primary),
          ),
        ),
    ],
  );
}
