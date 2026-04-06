import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandlordFinanceScreen extends StatefulWidget {
  const LandlordFinanceScreen({super.key});

  @override
  State<LandlordFinanceScreen> createState() => _LandlordFinanceScreenState();
}

class _LandlordFinanceScreenState extends State<LandlordFinanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedMonth = 3;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).padding.top + 16,
                20,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tài chính',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Month filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(6, (i) {
                        final month = i + 1;
                        final isSelected = month == _selectedMonth;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedMonth = month),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? cs.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? cs.primary
                                    : cs.onSurface.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Text(
                              'T$month/2026',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : cs.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Revenue Summary ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doanh thu Tháng $_selectedMonth/2026',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '78,500,000 đ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          color: Colors.greenAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '↑ 5.2% so với T${_selectedMonth - 1} (74.6M)',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _RevenueStatBox(
                            label: 'Đã thu',
                            value: '66.2M',
                            icon: Icons.check_circle_outline_rounded,
                            color: Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _RevenueStatBox(
                            label: 'Chưa thu',
                            value: '12.3M',
                            icon: Icons.hourglass_empty_rounded,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Collection Rate ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tỷ lệ thu tiền tháng này',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '21/25 phòng',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 21 / 25,
                        minHeight: 8,
                        backgroundColor: cs.primary.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '84% đã thanh toán',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          '4 phòng chưa đóng',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Section Header ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách hóa đơn',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.push('/landlord/finance/invoice-detail'),
                    child: Text(
                      'Xem tất cả →',
                      style: TextStyle(color: cs.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Invoice list ────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _InvoiceRow(
                  room: 'P.102',
                  name: 'Trần Thị Bình',
                  amount: '3,850,000 đ',
                  status: InvoiceStatus.paid,
                ),
                const SizedBox(height: 10),
                _InvoiceRow(
                  room: 'P.205',
                  name: 'Nguyễn Thị Linh',
                  amount: '4,250,000 đ',
                  status: InvoiceStatus.unpaid,
                  onRemind: () {},
                ),
                const SizedBox(height: 10),
                _InvoiceRow(
                  room: 'P.201',
                  name: 'Nguyễn Văn Minh',
                  amount: '3,800,000 đ',
                  status: InvoiceStatus.paid,
                ),
                const SizedBox(height: 10),
                _InvoiceRow(
                  room: 'P.301',
                  name: 'Lê Văn Cường',
                  amount: '4,100,000 đ',
                  status: InvoiceStatus.paid,
                ),
                const SizedBox(height: 10),
                _InvoiceRow(
                  room: 'P.105',
                  name: 'Phạm Thị Thu',
                  amount: '3,500,000 đ',
                  status: InvoiceStatus.overdue,
                  onRemind: () {},
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Revenue Stat Box ─────────────────────────────────────────────────────────

class _RevenueStatBox extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _RevenueStatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Invoice Row ──────────────────────────────────────────────────────────────

enum InvoiceStatus { paid, unpaid, overdue }

class _InvoiceRow extends StatelessWidget {
  final String room, name, amount;
  final InvoiceStatus status;
  final VoidCallback? onRemind;

  const _InvoiceRow({
    required this.room,
    required this.name,
    required this.amount,
    required this.status,
    this.onRemind,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    Color statusColor;
    String statusText;
    IconData statusIcon;
    switch (status) {
      case InvoiceStatus.paid:
        statusColor = Colors.green;
        statusText = 'Đã thu';
        statusIcon = Icons.check_circle_rounded;
        break;
      case InvoiceStatus.unpaid:
        statusColor = Colors.orange;
        statusText = 'Chưa thanh toán';
        statusIcon = Icons.schedule_rounded;
        break;
      case InvoiceStatus.overdue:
        statusColor = Colors.red;
        statusText = 'Quá hạn';
        statusIcon = Icons.warning_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$room · $name',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              if (onRemind != null)
                GestureDetector(
                  onTap: onRemind,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 12,
                          color: cs.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Gửi nhắc nhở',
                          style: TextStyle(
                            fontSize: 11,
                            color: cs.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
