import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../ticket/domain/entities/ticket.dart';
import '../../../ticket/presentation/bloc/ticket_cubit.dart';

extension TicketStatusColor on TicketStatus {
  Color get color {
    switch (this) {
      case TicketStatus.open:
        return Colors.red;
      case TicketStatus.inProgress:
        return Colors.orange;
      case TicketStatus.resolved:
      case TicketStatus.closed:
        return Colors.green;
    }
  }

  String get displayName {
    switch (this) {
      case TicketStatus.open:
        return 'Mới báo';
      case TicketStatus.inProgress:
        return 'Đang xử lý';
      case TicketStatus.resolved:
      case TicketStatus.closed:
        return 'Đã xử lý';
    }
  }
}

class LandlordIssueDetailScreen extends StatelessWidget {
  final Ticket ticket;

  const LandlordIssueDetailScreen({
    super.key,
    required this.ticket,
  });

  String _formatTime(DateTime time) {
    return DateFormat('dd/MM HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final statusColor = ticket.status.color;

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
          'Chi tiết sự cố',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Issue card header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border(
                  left: BorderSide(color: statusColor, width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.engineering_rounded,
                          color: statusColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ticket.id.substring(0, 8).toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                            Text(
                              ticket.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ticket.status.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Room & tenant
                  Column(
                    children: [
                      _InfoItem(
                        icon: Icons.door_front_door_rounded,
                        label: ticket.roomName ?? 'Phòng ?',
                      ),
                      const SizedBox(height: 8),
                      if (ticket.tenantName != null && ticket.tenantName!.isNotEmpty)
                        _InfoItem(
                          icon: Icons.person_outline,
                          label: ticket.tenantName!,
                        ),
                      if (ticket.tenantName != null && ticket.tenantName!.isNotEmpty)
                        const SizedBox(height: 8),
                      _InfoItem(icon: Icons.category_outlined, label: ticket.category?.displayName ?? 'Khác'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ticket.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Timeline
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tiến trình xử lý',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _TimelineStep(
                    icon: Icons.send_rounded,
                    title: 'Đã gửi báo cáo',
                    subtitle: 'Người thuê đã báo cáo',
                    time: _formatTime(ticket.createdAt),
                    isDone: true,
                    isFirst: true,
                    isActive: ticket.status == TicketStatus.open,
                  ),
                  _TimelineStep(
                    icon: Icons.engineering_rounded,
                    title: 'Đang xử lý',
                    subtitle: ticket.status == TicketStatus.open ? '' : 'Chủ nhà đã tiếp nhận và đang xử lý',
                    time: ticket.status != TicketStatus.open && ticket.updatedAt != null ? _formatTime(ticket.updatedAt!) : '',
                    isDone: ticket.status != TicketStatus.open,
                    isActive: ticket.status == TicketStatus.inProgress,
                  ),
                  _TimelineStep(
                    icon: Icons.verified_rounded,
                    title: 'Hoàn tất',
                    subtitle: ticket.status == TicketStatus.resolved ? 'Sự cố đã được giải quyết' : '',
                    time: ticket.status == TicketStatus.resolved && ticket.updatedAt != null ? _formatTime(ticket.updatedAt!) : '',
                    isDone: ticket.status == TicketStatus.resolved || ticket.status == TicketStatus.closed,
                    isLast: true,
                    isActive: ticket.status == TicketStatus.resolved || ticket.status == TicketStatus.closed,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            if (ticket.status != TicketStatus.resolved && ticket.status != TicketStatus.closed)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/landlord/chat'),
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 18,
                    ),
                    label: const Text(
                      'Nhắn tin',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final nextStatus = ticket.status == TicketStatus.open 
                          ? TicketStatus.inProgress 
                          : TicketStatus.resolved;
                      context.read<TicketCubit>().updateTicketStatus(ticket.id, nextStatus);
                      context.pop(); // Go back or show dialog then pop
                    },
                    label: Text(
                      ticket.status == TicketStatus.open ? 'Tiếp nhận' : 'Hoàn tất',
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoItem({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 14, color: cs.onSurface.withValues(alpha: 0.4)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, time;
  final bool isDone, isActive, isFirst, isLast;

  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isDone,
    this.isActive = false,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final color = isDone
        ? (isActive ? cs.primary : Colors.green)
        : cs.onSurface.withValues(alpha: 0.2);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, size: 14, color: color),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isDone
                    ? Colors.green.withValues(alpha: 0.3)
                    : cs.onSurface.withValues(alpha: 0.1),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDone
                        ? cs.onSurface
                        : cs.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                      height: 1.4,
                    ),
                  ),
                ],
                if (time.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 10,
                      color: cs.onSurface.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
