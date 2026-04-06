import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TenantMyRoomScreen extends StatefulWidget {
  const TenantMyRoomScreen({super.key});
  @override
  State<TenantMyRoomScreen> createState() => _TenantMyRoomScreenState();
}

class _TenantMyRoomScreenState extends State<TenantMyRoomScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: NestedScrollView(
        headerSliverBuilder: (ctx, inner) => [
          // SliverAppBar with image/gradient header
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: cs.primary,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.chat_bubble_rounded,
                  color: Colors.white,
                ),
                onPressed: () => context.push('/tenant/chat'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [cs.primary, cs.primary.withValues(alpha: 0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.apartment_rounded,
                        size: 96,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                  // Room info overlay
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'ĐANG THUÊ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Text(
                                      'Phòng 205 - Tầng 2',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  '45 Lê Lợi, Quận 1 · Khu A',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      '4.250.000 đ',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const Text(
                                      '/tháng',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabCtrl,
                  labelColor: cs.primary,
                  unselectedLabelColor: cs.onSurface.withValues(alpha: 0.45),
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  indicatorColor: cs.primary,
                  indicatorWeight: 2.5,
                  tabs: const [
                    Tab(text: 'Tổng quan'),
                    Tab(text: 'Tài sản'),
                    Tab(text: 'Lịch sử'),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            _OverviewTab(cs: cs, theme: theme),
            _AssetsTab(cs: cs, theme: theme),
            _HistoryTab(cs: cs, theme: theme),
          ],
        ),
      ),
    );
  }
}

// ── Tab 1: Overview ────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _OverviewTab({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Contract expiry warning
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_rounded, color: Colors.orange, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hợp đồng sắp hết hạn',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Còn 8 tháng · Kết thúc 01/12/2026',
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/tenant/contract'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Xem HĐ',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Landlord contact card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.primaryContainer.withValues(alpha: 0.4),
                  ),
                  child: Center(
                    child: Text(
                      'NH',
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nguyễn Văn Hùng',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Chủ nhà',
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _ContactButton(
                      icon: Icons.chat_bubble_rounded,
                      cs: cs,
                      onTap: () => context.push('/tenant/chat'),
                    ),
                    const SizedBox(width: 8),
                    _ContactButton(
                      icon: Icons.phone_rounded,
                      cs: cs,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Utilities costs this month
          _SectionCard(
            title: 'Chi phí tháng này',
            icon: Icons.data_usage_rounded,
            cs: cs,
            theme: theme,
            child: Column(
              children: [
                _CostBar(
                  label: 'Tiền phòng',
                  amount: 4250000,
                  max: 4250000,
                  color: cs.primary,
                  cs: cs,
                ),
                const SizedBox(height: 12),
                _CostBar(
                  label: 'Điện (57 kWh)',
                  amount: 199500,
                  max: 500000,
                  color: Colors.amber,
                  cs: cs,
                ),
                const SizedBox(height: 12),
                _CostBar(
                  label: 'Nước (4 m³)',
                  amount: 60000,
                  max: 200000,
                  color: Colors.blue,
                  cs: cs,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      '4.509.500 đ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.warning_amber_rounded,
                  label: 'Sự cố',
                  value: '2',
                  color: Colors.orange,
                  cs: cs,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle_rounded,
                  label: 'Đã xử lý',
                  value: '5',
                  color: Colors.green,
                  cs: cs,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.calendar_today_rounded,
                  label: 'Tháng thuê',
                  value: '13',
                  color: cs.primary,
                  cs: cs,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _CostBar extends StatelessWidget {
  final String label;
  final int amount, max;
  final Color color;
  final ColorScheme cs;
  const _CostBar({
    required this.label,
    required this.amount,
    required this.max,
    required this.color,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (amount / max).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
            Text(
              _fmt(amount),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  String _fmt(int v) {
    final s = v.toString();
    final r = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) r.write('.');
      r.write(s[i]);
    }
    return '${r.toString()} đ';
  }
}

// ── Tab 2: Assets ──────────────────────────────────────────────────────────────
class _AssetsTab extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _AssetsTab({required this.cs, required this.theme});

  static const _assets = [
    ('Điều hòa', Icons.ac_unit_rounded, 'Panasonic · Còn BH'),
    ('Nóng lạnh', Icons.water_rounded, 'Ariston · Bình thường'),
    ('Tủ lạnh', Icons.kitchen_rounded, 'Samsung · Bình thường'),
    ('Máy giặt', Icons.local_laundry_service_rounded, 'LG · Bình thường'),
    ('Giường', Icons.bed_rounded, 'Khung sắt · Bình thường'),
    ('Bàn học', Icons.desk_rounded, 'Gỗ ép · Bình thường'),
    ('Tủ quần áo', Icons.door_sliding_rounded, '2 cánh · Bình thường'),
    ('Wifi Router', Icons.wifi_rounded, 'TP-Link · Bình thường'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: _assets.length,
      itemBuilder: (ctx, i) {
        final a = _assets[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(a.$2, size: 18, color: cs.primary),
                  ),
                  const Spacer(),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                a.$1,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: Text(
                  a.$3,
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.45),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Tab 3: History ─────────────────────────────────────────────────────────────
class _HistoryTab extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _HistoryTab({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _HistoryItem(
          date: '01/04/2026',
          title: 'Thanh toán hóa đơn T3/2026',
          amount: '4.250.000 đ',
          positive: false,
        ),
        _HistoryItem(
          date: '15/03/2026',
          title: 'Sự cố điều hòa được xử lý',
          amount: '',
          positive: true,
        ),
        _HistoryItem(
          date: '01/03/2026',
          title: 'Thanh toán hóa đơn T2/2026',
          amount: '4.100.000 đ',
          positive: false,
        ),
        _HistoryItem(
          date: '01/02/2026',
          title: 'Ký hợp đồng thuê phòng',
          amount: '',
          positive: true,
        ),
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String date, title, amount;
  final bool positive;
  const _HistoryItem({
    required this.date,
    required this.title,
    required this.amount,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (positive ? Colors.green : Colors.orange).withValues(
                alpha: 0.1,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              positive ? Icons.check_rounded : Icons.receipt_long_rounded,
              size: 16,
              color: positive ? Colors.green : Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          if (amount.isNotEmpty)
            Text(
              amount,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: cs.error,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final ColorScheme cs;
  final ThemeData theme;
  final Widget child;
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.cs,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
          child: Row(
            children: [
              Icon(icon, size: 16, color: cs.primary),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  final ColorScheme cs;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    ),
  );
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final ColorScheme cs;
  final VoidCallback onTap;
  const _ContactButton({
    required this.icon,
    required this.cs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: cs.primary),
    ),
  );
}
