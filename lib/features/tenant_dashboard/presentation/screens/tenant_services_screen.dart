import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TenantServicesScreen extends StatelessWidget {
  const TenantServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Dịch vụ & Hỗ trợ',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: Icon(Icons.history_rounded, color: cs.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Active issue banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.build_rounded, color: Colors.orange, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('1 yêu cầu đang xử lý',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.orange)),
                  Text('Hỏng vòi nước phòng tắm · Đang xử lý',
                      style: TextStyle(fontSize: 12, color: Colors.orange)),
                ]),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.orange.withValues(alpha: 0.7)),
            ]),
          ),
          const SizedBox(height: 20),

          // Service request grid title
          Text('Báo sự cố / Yêu cầu dịch vụ',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.9,
            children: [
              _ServiceTile(icon: Icons.electrical_services_rounded, label: 'Điện', color: const Color(0xFFF59E0B), onTap: () => context.push('/tenant/services/report')),
              _ServiceTile(icon: Icons.water_drop_rounded, label: 'Nước', color: const Color(0xFF3B82F6), onTap: () => context.push('/tenant/services/report')),
              _ServiceTile(icon: Icons.ac_unit_rounded, label: 'Điều hòa', color: const Color(0xFF06B6D4), onTap: () => context.push('/tenant/services/report')),
              _ServiceTile(icon: Icons.wifi_rounded, label: 'Internet', color: const Color(0xFF8B5CF6), onTap: () => context.push('/tenant/services/report')),
              _ServiceTile(icon: Icons.cleaning_services_rounded, label: 'Vệ sinh', color: const Color(0xFF10B981), onTap: () => context.push('/tenant/services/report')),
              _ServiceTile(icon: Icons.lock_rounded, label: 'Khóa cửa', color: const Color(0xFF6366F1), onTap: () => context.push('/tenant/services/report')),
              _ServiceTile(icon: Icons.build_rounded, label: 'Sửa chữa', color: const Color(0xFFEF4444), onTap: () => context.push('/tenant/services/report')),
              _ServiceTile(icon: Icons.chat_bubble_rounded, label: 'Chat chủ', color: cs.primary, onTap: () => context.push('/tenant/chat')),
            ],
          ),
          const SizedBox(height: 24),

          // My issues
          Row(children: [
            Text('Sự cố của tôi',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Text('Xem tất cả', style: TextStyle(fontSize: 12, color: cs.primary)),
            ),
          ]),
          const SizedBox(height: 10),
          _IssueCard(
            title: 'Hỏng vòi nước phòng tắm',
            category: 'Nước',
            status: 'Đang xử lý',
            statusColor: Colors.orange,
            time: '03/04/2026 · 09:30',
            icon: Icons.water_drop_rounded,
            iconColor: const Color(0xFF3B82F6),
            onTap: () => context.push('/tenant/issue-detail'),
            cs: cs,
          ),
          const SizedBox(height: 8),
          _IssueCard(
            title: 'Sửa ổ điện tường phòng ngủ',
            category: 'Điện',
            status: 'Hoàn thành',
            statusColor: Colors.green,
            time: '20/03/2026 · 15:00',
            icon: Icons.electrical_services_rounded,
            iconColor: const Color(0xFFF59E0B),
            onTap: () => context.push('/tenant/issue-detail'),
            cs: cs,
          ),
          const SizedBox(height: 24),

          // Useful resources
          Text('Tài nguyên hữu ích',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              _ResourceRow(icon: Icons.help_outline_rounded, label: 'Hướng dẫn sử dụng', cs: cs),
              Divider(height: 1, indent: 56, color: cs.outlineVariant.withValues(alpha: 0.4)),
              _ResourceRow(icon: Icons.phone_in_talk_rounded, label: 'Liên hệ khẩn cấp: 1900 xxxx', cs: cs),
              Divider(height: 1, indent: 56, color: cs.outlineVariant.withValues(alpha: 0.4)),
              _ResourceRow(icon: Icons.rule_rounded, label: 'Nội quy khu trọ', cs: cs),
            ]),
          ),
          const SizedBox(height: 100),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tenant/services/report'),
        backgroundColor: cs.primary,
        icon: const Icon(Icons.add_circle_rounded, color: Colors.white),
        label: const Text('Báo sự cố mới', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ServiceTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 26, color: color),
        const SizedBox(height: 5),
        Text(label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
            textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    ),
  );
}

class _IssueCard extends StatelessWidget {
  final String title, category, status, time;
  final Color statusColor, iconColor;
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme cs;
  const _IssueCard({required this.title, required this.category, required this.status, required this.statusColor, required this.time, required this.icon, required this.iconColor, required this.onTap, required this.cs});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 3),
          Text(time, style: TextStyle(fontSize: 11, color: cs.onSurface.withValues(alpha: 0.45))),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor)),
        ),
      ]),
    ),
  );
}

class _ResourceRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme cs;
  const _ResourceRow({required this.icon, required this.label, required this.cs});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {},
    borderRadius: BorderRadius.circular(20),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: cs.primary),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
        Icon(Icons.chevron_right_rounded, size: 18, color: cs.onSurface.withValues(alpha: 0.3)),
      ]),
    ),
  );
}
