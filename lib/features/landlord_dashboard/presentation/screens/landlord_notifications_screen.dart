import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandlordNotificationsScreen extends StatelessWidget {
  const LandlordNotificationsScreen({super.key});

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
                16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thông báo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Đọc tất cả',
                      style: TextStyle(color: cs.primary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Today ──────────────────────────────────────────────────────────
          _SectionHeader(title: 'Hôm nay'),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _NotifItem(
                  icon: Icons.payments_rounded,
                  iconColor: Colors.green,
                  title: 'P.201 - Anh Minh đã thanh toán',
                  subtitle: '3,800,000 đ · Chuyển khoản VCB',
                  isUnread: true,
                ),
                const SizedBox(height: 8),
                _NotifItem(
                  icon: Icons.engineering_rounded,
                  iconColor: Colors.red,
                  title: 'Sự cố mới: Điều hòa không mát',
                  subtitle: 'P.102 · Trần Thị Bình · Khẩn cấp',
                  isUnread: true,
                  actionLabel: 'Xem & Xử lý',
                  onAction: () =>
                      context.push('/landlord/operations/issue-detail'),
                ),
                const SizedBox(height: 8),
                _NotifItem(
                  icon: Icons.chat_bubble_rounded,
                  iconColor: Colors.blue,
                  title: 'Tin nhắn mới từ người tìm phòng',
                  subtitle: 'Nguyễn Văn K hỏi về Phòng 201 (3.5M/th)',
                  isUnread: true,
                  actionLabel: 'Trả lời',
                  onAction: () => context.push('/landlord/chat'),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),

          // ── Yesterday ─────────────────────────────────────────────────────
          _SectionHeader(title: 'Hôm qua'),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _NotifItem(
                  icon: Icons.receipt_long_rounded,
                  iconColor: cs.primary,
                  title: 'Đã gửi thành công 22 hóa đơn T3/2026',
                  subtitle: 'Tổng: 78.5M · 4 phòng chưa nhập chỉ số',
                  isUnread: false,
                ),
                const SizedBox(height: 8),
                _NotifItem(
                  icon: Icons.assignment_late_rounded,
                  iconColor: Colors.orange,
                  title: 'Nhắc: 3 hợp đồng sắp hết hạn',
                  subtitle: 'P.301, P.105, P.208 · Trong 30 ngày tới',
                  isUnread: false,
                  actionLabel: 'Xem danh sách',
                  onAction: () {},
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),

          // ── Last Week ────────────────────────────────────────────────────
          _SectionHeader(title: 'Tuần trước'),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _NotifItem(
                  icon: Icons.calendar_today_rounded,
                  iconColor: Colors.teal,
                  title: 'Yêu cầu xem phòng 201 - Nguyễn V.K',
                  subtitle: 'T7, 22/03 · 10:00-11:00',
                  isUnread: false,
                ),
                const SizedBox(height: 8),
                _NotifItem(
                  icon: Icons.send_rounded,
                  iconColor: Colors.grey,
                  title: 'Đã gửi nhắc nhở thanh toán cho 5 phòng quá hạn',
                  subtitle: 'Xem lịch sử gửi',
                  isUnread: false,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section header sliver ────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.45),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ─── Notification Item ────────────────────────────────────────────────────────

class _NotifItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final bool isUnread;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _NotifItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isUnread,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnread ? cs.primary.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 6, top: 2),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isUnread
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                if (actionLabel != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onAction,
                    child: Row(
                      children: [
                        Text(
                          actionLabel!,
                          style: TextStyle(
                            color: cs.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 12,
                          color: cs.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
