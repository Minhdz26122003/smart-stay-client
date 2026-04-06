import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TenantContractScreen extends StatelessWidget {
  const TenantContractScreen({super.key});

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
              child: Column(children: [
                Row(children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () => context.pop(),
                  ),
                  const Expanded(
                    child: Text('Hợp đồng thuê phòng',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.download_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Đang tải xuống hợp đồng...'),
                        backgroundColor: cs.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ));
                    },
                  ),
                ]),
                const SizedBox(height: 16),
                // Contract summary pill
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.description_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phòng 205 - Khu A',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800)),
                              Text('45 Lê Lợi, Quận 1, TP.HCM',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.green.withValues(alpha: 0.5)),
                        ),
                        child: const Text('Hiệu lực',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    // Duration progress
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Thời hạn hợp đồng',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            const Text('Còn 8 tháng',
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ]),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: 4 / 12,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('01/12/2025',
                                style: TextStyle(color: Colors.white60, fontSize: 10)),
                            Text('01/12/2026',
                                style: TextStyle(color: Colors.white60, fontSize: 10)),
                          ]),
                    ]),
                  ]),
                ),
              ]),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // Expiry warning
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.orange, size: 20),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Hợp đồng còn 8 tháng. Liên hệ chủ nhà trước 1 tháng để gia hạn.',
                        style: TextStyle(fontSize: 12, color: Colors.orange, height: 1.4),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/tenant/chat'),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: const Text('Chat',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                              fontWeight: FontWeight.w700)),
                    ),
                  ]),
                ),
                const SizedBox(height: 14),

                // Parties card
                _ContractCard(
                  icon: Icons.people_rounded,
                  title: 'Các bên ký kết',
                  cs: cs,
                  theme: theme,
                  child: Column(children: [
                    _PartyBox(
                        label: 'Bên cho thuê',
                        name: 'Nguyễn Văn Hùng',
                        detail: '0901 234 000 · Chủ nhà',
                        icon: Icons.apartment_rounded,
                        cs: cs),
                    const SizedBox(height: 10),
                    _PartyBox(
                        label: 'Bên thuê',
                        name: 'Nguyễn Thị Linh',
                        detail: '0901 234 567 · Người thuê',
                        icon: Icons.person_rounded,
                        cs: cs),
                  ]),
                ),
                const SizedBox(height: 14),

                // Terms
                _ContractCard(
                  icon: Icons.gavel_rounded,
                  title: 'Điều khoản chính',
                  cs: cs,
                  theme: theme,
                  child: Column(children: [
                    _TermRow2(icon: Icons.home_work_rounded, label: 'Phòng thuê', value: 'Phòng 205, Tầng 2, Khu A', cs: cs),
                    _TermRow2(icon: Icons.payments_rounded, label: 'Tiền thuê', value: '4.250.000 đ/tháng', cs: cs, highlight: true),
                    _TermRow2(icon: Icons.account_balance_rounded, label: 'Đặt cọc', value: '8.500.000 đ (2 tháng)', cs: cs),
                    _TermRow2(icon: Icons.calendar_month_rounded, label: 'Thời hạn', value: '12 tháng (01/12/2025 - 01/12/2026)', cs: cs),
                    _TermRow2(icon: Icons.today_rounded, label: 'Ngày thanh toán', value: 'Ngày 15 hàng tháng', cs: cs),
                  ]),
                ),
                const SizedBox(height: 14),

                // Utilities pricing
                _ContractCard(
                  icon: Icons.bolt_rounded,
                  title: 'Giá dịch vụ',
                  cs: cs,
                  theme: theme,
                  child: Row(children: [
                    Expanded(child: _UtilBox(icon: Icons.electric_bolt_rounded, label: 'Điện', value: '3.500đ/kWh', color: Colors.amber, cs: cs)),
                    const SizedBox(width: 10),
                    Expanded(child: _UtilBox(icon: Icons.water_drop_rounded, label: 'Nước', value: '15.000đ/m³', color: Colors.blue, cs: cs)),
                    const SizedBox(width: 10),
                    Expanded(child: _UtilBox(icon: Icons.wifi_rounded, label: 'Wifi', value: 'Miễn phí', color: Colors.green, cs: cs)),
                  ]),
                ),
                const SizedBox(height: 14),

                // House rules
                _ContractCard(
                  icon: Icons.rule_rounded,
                  title: 'Nội quy khu trọ',
                  cs: cs,
                  theme: theme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final rule in [
                        'Không nuôi thú cưng trong phòng',
                        'Không gây ồn ào sau 22:00',
                        'Giữ gìn vệ sinh khu vực chung',
                        'Thông báo trước 30 ngày khi trả phòng',
                        'Không tự ý cải tạo, sửa chữa phòng',
                      ])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(top: 6, right: 10),
                                  decoration: BoxDecoration(
                                      color: cs.primary, shape: BoxShape.circle),
                                ),
                                Expanded(
                                  child: Text(rule,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color:
                                              cs.onSurface.withValues(alpha: 0.7),
                                          height: 1.4)),
                                ),
                              ]),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// Helpers
class _ContractCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final ColorScheme cs;
  final ThemeData theme;
  final Widget child;
  const _ContractCard({required this.icon, required this.title, required this.cs, required this.theme, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
        child: Row(children: [
          Icon(icon, size: 18, color: cs.primary),
          const SizedBox(width: 8),
          Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        ]),
      ),
      const Divider(height: 1),
      Padding(padding: const EdgeInsets.all(18), child: child),
    ]),
  );
}

class _PartyBox extends StatelessWidget {
  final String label, name, detail;
  final IconData icon;
  final ColorScheme cs;
  const _PartyBox({required this.label, required this.name, required this.detail, required this.icon, required this.cs});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: cs.primaryContainer.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: cs.primary),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 10, color: cs.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.w600)),
        Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        Text(detail, style: TextStyle(fontSize: 11, color: cs.onSurface.withValues(alpha: 0.45))),
      ])),
    ]),
  );
}

class _TermRow2 extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final ColorScheme cs;
  final bool highlight;
  const _TermRow2({required this.icon, required this.label, required this.value, required this.cs, this.highlight = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: cs.primary),
      ),
      const SizedBox(width: 10),
      SizedBox(width: 100, child: Text(label, style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.55)))),
      Expanded(
        child: Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: highlight ? cs.primary : cs.onSurface)),
      ),
    ]),
  );
}

class _UtilBox extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  final ColorScheme cs;
  const _UtilBox({required this.icon, required this.label, required this.value, required this.color, required this.cs});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 18, color: color),
      const SizedBox(height: 6),
      Text(label, style: TextStyle(fontSize: 10, color: cs.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.w600)),
      const SizedBox(height: 2),
      Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    ]),
  );
}
