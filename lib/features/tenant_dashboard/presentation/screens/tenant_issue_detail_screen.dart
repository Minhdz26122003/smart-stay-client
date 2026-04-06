import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TenantIssueDetailScreen extends StatelessWidget {
  const TenantIssueDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 56, 16, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade600, Colors.orange.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                    onPressed: () => context.pop(),
                  ),
                  const Expanded(
                    child: Text('Chi tiết sự cố', textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                    onPressed: () {},
                  ),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('ISS-001 · Nước', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                    ),
                    child: const Text('Đang xử lý', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 10),
                const Text('Hỏng vòi nước phòng tắm',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.access_time_rounded, color: Colors.white70, size: 13),
                  const SizedBox(width: 5),
                  const Text('Báo lúc 09:30 · 03/04/2026',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(width: 12),
                  const Icon(Icons.place_rounded, color: Colors.white70, size: 13),
                  const SizedBox(width: 5),
                  const Text('Phòng tắm', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ]),
              ]),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // Progress timeline
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Icon(Icons.timeline_rounded, size: 18, color: cs.primary),
                      const SizedBox(width: 8),
                      Text('Tiến trình xử lý',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    ]),
                    const Divider(height: 20),
                    _TimelineStep(
                      icon: Icons.check_circle_rounded,
                      color: Colors.green,
                      label: 'Đã nhận báo cáo',
                      description: 'Chủ nhà đã tiếp nhận yêu cầu',
                      time: '03/04 · 09:35',
                      done: true,
                      cs: cs,
                    ),
                    _TimelineStep(
                      icon: Icons.engineering_rounded,
                      color: Colors.orange,
                      label: 'Đang xử lý',
                      description: 'Thợ sẽ đến vào 03/04 lúc 14:00',
                      time: '03/04 · 10:00',
                      done: true,
                      cs: cs,
                    ),
                    _TimelineStep(
                      icon: Icons.check_circle_outline_rounded,
                      color: cs.onSurface.withValues(alpha: 0.25),
                      label: 'Hoàn thành',
                      description: 'Chờ kỹ thuật viên hoàn thiện',
                      time: '',
                      done: false,
                      cs: cs,
                      isLast: true,
                    ),
                  ]),
                ),
                const SizedBox(height: 14),

                // Description
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Icon(Icons.description_rounded, size: 18, color: cs.primary),
                      const SizedBox(width: 8),
                      Text('Mô tả sự cố',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    ]),
                    const Divider(height: 20),
                    Text(
                      'Vòi nước trong lavabo phòng tắm bị rỉ, nước chảy liên tục không tắt được kể từ sáng nay. Đã cố khóa nhưng không ăn thua.',
                      style: TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.75), height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    // Photo grid
                    Row(children: [
                      _PhotoPlaceholder(color: Colors.blue.withValues(alpha: 0.1), icon: Icons.water_drop_rounded),
                      const SizedBox(width: 8),
                      _PhotoPlaceholder(color: Colors.orange.withValues(alpha: 0.1), icon: Icons.image_rounded),
                    ]),
                  ]),
                ),
                const SizedBox(height: 14),

                // Landlord reply
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: cs.primaryContainer.withValues(alpha: 0.4),
                        child: Text('NH', style: TextStyle(color: cs.primary, fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Nguyễn Văn Hùng (Chủ nhà)',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          Text('03/04/2026 · 10:00',
                              style: TextStyle(fontSize: 10, color: cs.onSurface.withValues(alpha: 0.4))),
                        ]),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    Text(
                      'Em ơi, chiều 03/04 chị sẽ cho thợ đến lúc 14:00 nhé. Em ở nhà hay nhờ ai mở cửa giúp không?',
                      style: TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.8), height: 1.45),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),

                // Action buttons
                Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/tenant/chat'),
                      icon: Icon(Icons.chat_bubble_rounded, size: 16, color: cs.primary),
                      label: Text('Chat chủ nhà', style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: cs.primary.withValues(alpha: 0.4)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.star_rounded, size: 16, color: Colors.white),
                      label: const Text('Đánh giá', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 60),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, description, time;
  final bool done, isLast;
  final ColorScheme cs;
  const _TimelineStep({required this.icon, required this.color, required this.label, required this.description, required this.time, required this.done, required this.cs, this.isLast = false});

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Column(children: [
      Icon(icon, size: 22, color: color),
      if (!isLast)
        Container(
          width: 2,
          height: 42,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: done ? cs.primary.withValues(alpha: 0.25) : cs.onSurface.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
    ]),
    const SizedBox(width: 14),
    Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: done ? cs.onSurface : cs.onSurface.withValues(alpha: 0.4))),
          if (done) ...[
            const SizedBox(height: 3),
            Text(description, style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.6))),
            if (time.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(time, style: TextStyle(fontSize: 10, color: cs.onSurface.withValues(alpha: 0.4))),
            ],
          ],
        ]),
      ),
    ),
  ]);
}

class _PhotoPlaceholder extends StatelessWidget {
  final Color color;
  final IconData icon;
  const _PhotoPlaceholder({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
    child: Icon(icon, size: 32, color: Colors.white.withValues(alpha: 0.5)),
  );
}
