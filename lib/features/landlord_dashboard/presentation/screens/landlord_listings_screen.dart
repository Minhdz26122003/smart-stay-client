import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _ListingData {
  final String title, subtitle, price, status;
  final Color statusColor;
  final int views, inquiries;
  const _ListingData(
    this.title,
    this.subtitle,
    this.price,
    this.status,
    this.statusColor,
    this.views,
    this.inquiries,
  );
}

class LandlordListingsScreen extends StatelessWidget {
  const LandlordListingsScreen({super.key});

  static const _listings = [
    _ListingData(
      'Phòng đẹp trung tâm có nội thất',
      'Phòng 102 - Khu trọ Minh Phát · Bình Thạnh',
      '3.000.000 đ/tháng',
      'Đang hiển thị',
      Colors.green,
      245,
      12,
    ),
    _ListingData(
      'Phòng giá rẻ gần Đại học',
      'Phòng 302 - Khu trọ Minh Phát · Bình Thạnh',
      '2.500.000 đ/tháng',
      'Đang hiển thị',
      Colors.green,
      188,
      8,
    ),
    _ListingData(
      'Studio Mini Bình Thạnh full nội thất',
      'Phòng A1 - Nhà trọ Bình Thạnh · Quận 1',
      '2.800.000 đ/tháng',
      'Đã ẩn',
      Colors.grey,
      92,
      3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final activeCount = _listings
        .where((l) => l.status == 'Đang hiển thị')
        .length;
    final hiddenCount = _listings.where((l) => l.status == 'Đã ẩn').length;
    final totalViews = _listings.fold<int>(0, (sum, l) => sum + l.views);

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
          'Quản lý đăng tin',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // Stats
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                _StatBox(
                  label: 'Đang đăng',
                  value: '$activeCount',
                  color: Colors.green,
                ),
                const SizedBox(width: 10),
                _StatBox(
                  label: 'Đã ẩn',
                  value: '$hiddenCount',
                  color: Colors.grey,
                ),
                const SizedBox(width: 10),
                _StatBox(
                  label: 'Lượt xem',
                  value: '$totalViews',
                  color: cs.primary,
                ),
              ],
            ),
          ),
          // Listing list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _listings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final l = _listings[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Image placeholder
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Container(
                          height: 110,
                          color: cs.primaryContainer.withValues(alpha: 0.3),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.apartment_rounded,
                                  size: 40,
                                  color: cs.primary.withValues(alpha: 0.3),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: l.statusColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    l.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l.title,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  l.price,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: cs.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                l.subtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Stats + actions row
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.visibility_outlined,
                                      size: 14,
                                      color: cs.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${l.views}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: cs.onSurface.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 14),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.event_rounded,
                                      size: 14,
                                      color: cs.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${l.inquiries} lịch hẹn',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: cs.onSurface.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                OutlinedButton(
                                  onPressed: () =>
                                      context.push('/landlord/add-board-post'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Chỉnh sửa',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/landlord/add-board-post'),
        backgroundColor: cs.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Đăng tin mới',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
