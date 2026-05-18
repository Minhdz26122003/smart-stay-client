import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../ticket/domain/entities/ticket.dart';
import '../../../ticket/presentation/bloc/ticket_cubit.dart';
import '../../../ticket/presentation/bloc/ticket_state.dart';

extension TicketStatusColor on TicketStatus {
  Color get color {
    switch (this) {
      case TicketStatus.pending:
        return Colors.red;
      case TicketStatus.inProgress:
        return Colors.orange;
      case TicketStatus.resolved:
        return Colors.green;
      case TicketStatus.cancelled:
        return Colors.grey;
    }
  }
}

class LandlordIssueDetailScreen extends StatefulWidget {
  final Ticket ticket;

  const LandlordIssueDetailScreen({
    super.key,
    required this.ticket,
  });

  @override
  State<LandlordIssueDetailScreen> createState() => _LandlordIssueDetailScreenState();
}

class _LandlordIssueDetailScreenState extends State<LandlordIssueDetailScreen> {
  bool _isLoadingVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final statusColor = widget.ticket.status.color;

    return BlocListener<TicketCubit, TicketState>(
      listener: (context, state) {
        if (state is TicketStatusUpdating &&
            state.ticketId == widget.ticket.id &&
            state.isLandlord) {
          _isLoadingVisible = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is TicketStatusUpdateSuccess &&
            state.ticketId == widget.ticket.id &&
            state.isLandlord) {
          _closeLoading(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.newStatus == TicketStatus.cancelled
                    ? 'Da huy ticket thanh cong.'
                    : 'Cap nhat trang thai ticket thanh cong.',
              ),
            ),
          );
          context.pop(true);
        } else if (state is TicketStatusUpdateError &&
            state.ticketId == widget.ticket.id &&
            state.isLandlord) {
          _closeLoading(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: cs.onSurface),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Chi tiet su co',
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
                                widget.ticket.id.substring(0, 8).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                              Text(
                                widget.ticket.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.ticket.status.displayName,
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
                    Column(
                      children: [
                        _InfoItem(
                          icon: Icons.door_front_door_rounded,
                          label: widget.ticket.roomName ?? 'Phong ?',
                        ),
                        const SizedBox(height: 8),
                        if (widget.ticket.tenantName != null &&
                            widget.ticket.tenantName!.isNotEmpty)
                          _InfoItem(
                            icon: Icons.person_outline,
                            label: widget.ticket.tenantName!,
                          ),
                        if (widget.ticket.tenantName != null &&
                            widget.ticket.tenantName!.isNotEmpty)
                          const SizedBox(height: 8),
                        _InfoItem(
                          icon: Icons.category_outlined,
                          label: widget.ticket.category?.displayName ?? 'Khac',
                        ),
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
                        widget.ticket.description,
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
                      'Tien trinh xu ly',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 16),
                    _TimelineStep(
                      icon: Icons.send_rounded,
                      title: 'Da gui bao cao',
                      subtitle: 'Nguoi thue da bao cao su co',
                      time: _formatTime(widget.ticket.createdAt),
                      isDone: true,
                      isFirst: true,
                      isActive: widget.ticket.status == TicketStatus.pending,
                    ),
                    _TimelineStep(
                      icon: Icons.engineering_rounded,
                      title: 'Dang xu ly',
                      subtitle: widget.ticket.status == TicketStatus.pending
                          ? ''
                          : 'Chu nha da tiep nhan va dang xu ly',
                      time: widget.ticket.status == TicketStatus.inProgress &&
                              widget.ticket.updatedAt != null
                          ? _formatTime(widget.ticket.updatedAt!)
                          : '',
                      isDone: widget.ticket.status != TicketStatus.pending,
                      isActive: widget.ticket.status == TicketStatus.inProgress,
                    ),
                    _TimelineStep(
                      icon: widget.ticket.status == TicketStatus.cancelled
                          ? Icons.block_rounded
                          : Icons.verified_rounded,
                      title: widget.ticket.status == TicketStatus.cancelled
                          ? 'Da huy'
                          : 'Hoan tat',
                      subtitle: widget.ticket.status == TicketStatus.cancelled
                          ? 'Ticket da duoc huy'
                          : widget.ticket.status == TicketStatus.resolved
                              ? 'Su co da duoc giai quyet'
                              : '',
                      time: widget.ticket.status.isFinal && widget.ticket.updatedAt != null
                          ? _formatTime(widget.ticket.updatedAt!)
                          : '',
                      isDone: widget.ticket.status.isFinal,
                      isLast: true,
                      isActive: widget.ticket.status.isFinal,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (!widget.ticket.status.isFinal)
                Row(
                  children: [
                    if (widget.ticket.status == TicketStatus.pending) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _cancelTicket,
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: const Text(
                            'Huy',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ] else ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.push('/landlord/chat'),
                          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                          label: const Text(
                            'Nhan tin',
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
                    ],
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _advanceTicket,
                        label: Text(
                          widget.ticket.status == TicketStatus.pending
                              ? 'Tiep nhan'
                              : 'Hoan tat',
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
      ),
    );
  }

  void _advanceTicket() {
    final nextStatus = widget.ticket.status == TicketStatus.pending
        ? TicketStatus.inProgress
        : TicketStatus.resolved;
    context.read<TicketCubit>().updateTicketStatus(widget.ticket.id, nextStatus);
  }

  void _cancelTicket() {
    context.read<TicketCubit>().updateTicketStatus(
          widget.ticket.id,
          TicketStatus.cancelled,
        );
  }

  void _closeLoading(BuildContext context) {
    if (_isLoadingVisible) {
      Navigator.of(context, rootNavigator: true).pop();
      _isLoadingVisible = false;
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat('dd/MM HH:mm').format(time);
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
          style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool isDone;
  final bool isActive;
  final bool isFirst;
  final bool isLast;

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
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: color),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 38,
                color: isDone ? color.withValues(alpha: 0.3) : cs.onSurface.withValues(alpha: 0.08),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.6)),
                  ),
                ],
                if (time.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: TextStyle(fontSize: 10, color: cs.onSurface.withValues(alpha: 0.4)),
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
