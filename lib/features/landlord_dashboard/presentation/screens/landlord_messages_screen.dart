import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _Conversation {
  final String name, lastMessage, time, initials;
  final bool hasAppointment, unread;
  final int unreadCount;
  const _Conversation(
      {required this.name,
      required this.lastMessage,
      required this.time,
      required this.initials,
      this.hasAppointment = false,
      this.unread = false,
      this.unreadCount = 0});
}

class LandlordMessagesScreen extends StatelessWidget {
  const LandlordMessagesScreen({super.key});

  static const _conversations = [
    _Conversation(
      name: 'Nguyễn B',
      lastMessage: 'Chị ơi phòng mặt tiền giá sao...',
      time: '10:32',
      initials: 'NB',
      unread: true,
      unreadCount: 2,
    ),
    _Conversation(
      name: 'Trần V. C',
      lastMessage: 'Yêu cầu đến xem phòng lúc 18:00 ngày 25/9',
      time: '09:15',
      initials: 'VC',
      hasAppointment: true,
      unread: true,
      unreadCount: 1,
    ),
    _Conversation(
      name: 'Phòng 102 - Lan',
      lastMessage: 'Tháng này em vừa chuyển khoản cọc điện rồi ạ',
      time: 'Hôm qua',
      initials: 'PL',
    ),
    _Conversation(
      name: 'Nguyễn Thị Linh',
      lastMessage: 'Em đã gửi ảnh sự cố vòi nước rồi ạ',
      time: '2 ngày',
      initials: 'NL',
    ),
  ];

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
        title: Text('Tin nhắn',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_note_rounded, color: cs.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Today's appointment banner
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.primary.withValues(alpha: 0.1),
                    cs.primaryContainer.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
              ),
              child: Row(children: [
                Icon(Icons.event_rounded, color: cs.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hôm nay có 2 lịch hẹn xem phòng!',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700, color: cs.primary)),
                      Text('18:00 - Trần V.C · 20:00 - Phạm Q.A',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.primary.withValues(alpha: 0.7))),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: cs.primary.withValues(alpha: 0.5)),
              ]),
            ),
          ),
          // Search
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm hội thoại...',
                hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.4)),
                prefixIcon: Icon(Icons.search_rounded,
                    color: cs.onSurface.withValues(alpha: 0.4)),
                filled: true,
                fillColor: const Color(0xFFF8F9FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          // Conversation list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _conversations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                final conv = _conversations[i];
                return GestureDetector(
                  onTap: () => context.push('/landlord/chat'),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(children: [
                      Stack(children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: cs.primaryContainer,
                          child: Text(conv.initials,
                              style: TextStyle(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700)),
                        ),
                        if (conv.unread)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: cs.primary,
                                shape: BoxShape.circle,
                                border: const Border.fromBorderSide(
                                    BorderSide(color: Colors.white, width: 2)),
                              ),
                            ),
                          ),
                      ]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(conv.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: conv.unread
                                          ? FontWeight.w700
                                          : FontWeight.w500)),
                              if (conv.hasAppointment) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text('Lịch hẹn',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ]),
                            const SizedBox(height: 2),
                            Text(
                              conv.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: conv.unread
                                    ? cs.onSurface.withValues(alpha: 0.7)
                                    : cs.onSurface.withValues(alpha: 0.45),
                                fontWeight: conv.unread
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(conv.time,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: conv.unread
                                      ? cs.primary
                                      : cs.onSurface.withValues(alpha: 0.4))),
                          if (conv.unreadCount > 0) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: cs.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('${conv.unreadCount}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
