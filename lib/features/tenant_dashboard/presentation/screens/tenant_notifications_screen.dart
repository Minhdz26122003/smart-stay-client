import 'package:flutter/material.dart';

class TenantNotificationsScreen extends StatefulWidget {
  const TenantNotificationsScreen({super.key});

  @override
  State<TenantNotificationsScreen> createState() =>
      _TenantNotificationsScreenState();
}

class _TenantNotificationsScreenState extends State<TenantNotificationsScreen> {
  final Set<int> _readIds = {3, 4};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Thông báo',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: () => setState(() => _readIds.addAll([0, 1, 2, 3, 4])),
            child: Text('Đọc tất cả',
                style: TextStyle(
                    fontSize: 13, color: cs.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        children: [
          _DateHeader('Hôm nay'),
          _NotifCard(
            id: 0,
            icon: Icons.receipt_long_rounded,
            iconColor: Colors.orange,
            title: 'Hóa đơn T4/2026 đã sẵn sàng',
            body:
                'Số tiền: 4.509.500 đ · Hạn thanh toán: 25/04/2026. Thanh toán đúng hạn để tránh phí phạt.',
            time: '10:30',
            isRead: _readIds.contains(0),
            onTap: () => setState(() => _readIds.add(0)),
            cs: cs,
            theme: theme,
          ),
          _NotifCard(
            id: 1,
            icon: Icons.build_rounded,
            iconColor: Colors.teal,
            title: 'Bảo trì hệ thống nước',
            body:
                'Dự kiến ngày 10/04 từ 8:00-12:00. Vui lòng dự phòng nước sinh hoạt.',
            time: '08:00',
            isRead: _readIds.contains(1),
            onTap: () => setState(() => _readIds.add(1)),
            cs: cs,
            theme: theme,
          ),
          _DateHeader('Hôm qua'),
          _NotifCard(
            id: 2,
            icon: Icons.check_circle_rounded,
            iconColor: Colors.green,
            title: 'Sự cố đã được xử lý ✅',
            body:
                'Yêu cầu sửa vòi nước phòng tắm đã hoàn thành. Đánh giá dịch vụ để giúp chúng tôi cải thiện nhé!',
            time: '14:00',
            isRead: _readIds.contains(2),
            onTap: () => setState(() => _readIds.add(2)),
            cs: cs,
            theme: theme,
            hasAction: true,
            actionLabel: 'Đánh giá',
          ),
          _NotifCard(
            id: 3,
            icon: Icons.campaign_rounded,
            iconColor: cs.primary,
            title: 'Thông báo từ chủ nhà',
            body:
                'Khu trọ sẽ tạm ngừng điện từ 8:00-12:00 ngày 05/04 để sửa chữa hệ thống điện. Xin lỗi vì sự bất tiện.',
            time: '09:00',
            isRead: _readIds.contains(3),
            onTap: () => setState(() => _readIds.add(3)),
            cs: cs,
            theme: theme,
          ),
          _DateHeader('Tuần trước'),
          _NotifCard(
            id: 4,
            icon: Icons.description_rounded,
            iconColor: Colors.purple,
            title: 'Hợp đồng sắp hết hạn',
            body:
                'Hợp đồng thuê phòng của bạn còn 8 tháng (kết thúc 01/12/2026). Liên hệ chủ nhà để được gia hạn.',
            time: '3 ngày trước',
            isRead: _readIds.contains(4),
            onTap: () => setState(() => _readIds.add(4)),
            cs: cs,
            theme: theme,
            hasAction: true,
            actionLabel: 'Xem HĐ',
          ),
        ],
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String label;
  const _DateHeader(this.label);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Row(children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 0.3)),
          const SizedBox(width: 8),
          Expanded(
              child: Divider(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2))),
        ]),
      );
}

class _NotifCard extends StatelessWidget {
  final int id;
  final IconData icon;
  final Color iconColor;
  final String title, body, time;
  final bool isRead;
  final VoidCallback onTap;
  final ColorScheme cs;
  final ThemeData theme;
  final bool hasAction;
  final String actionLabel;

  const _NotifCard({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.onTap,
    required this.cs,
    required this.theme,
    this.hasAction = false,
    this.actionLabel = '',
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isRead
                ? Colors.white
                : cs.primaryContainer.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
            border: isRead
                ? null
                : Border.all(color: cs.primary.withValues(alpha: 0.15)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                              color: cs.onSurface),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: cs.primary, shape: BoxShape.circle),
                        ),
                    ]),
                    const SizedBox(height: 4),
                    Text(body,
                        style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurface.withValues(alpha: 0.55),
                            height: 1.4),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(children: [
                      Icon(Icons.access_time_rounded,
                          size: 10,
                          color: cs.onSurface.withValues(alpha: 0.35)),
                      const SizedBox(width: 4),
                      Text(time,
                          style: TextStyle(
                              fontSize: 10,
                              color: cs.onSurface.withValues(alpha: 0.4))),
                      if (hasAction) ...[
                        const Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(actionLabel,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: cs.primary)),
                          ),
                        ),
                      ],
                    ]),
                  ]),
            ),
          ]),
        ),
      );
}
