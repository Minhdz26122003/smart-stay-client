import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../ticket/domain/entities/ticket.dart';
import '../../../ticket/presentation/bloc/ticket_cubit.dart';
import '../../../ticket/presentation/bloc/ticket_state.dart';

class TenantIssueDetailScreen extends StatefulWidget {
  final Ticket ticket;

  const TenantIssueDetailScreen({super.key, required this.ticket});

  @override
  State<TenantIssueDetailScreen> createState() => _TenantIssueDetailScreenState();
}

class _TenantIssueDetailScreenState extends State<TenantIssueDetailScreen> {
  bool _isLoadingVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final statusColor = _statusColor(widget.ticket.status);

    return BlocListener<TicketCubit, TicketState>(
      listener: (context, state) {
        if (state is TicketStatusUpdating &&
            state.ticketId == widget.ticket.id &&
            !state.isLandlord) {
          _isLoadingVisible = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is TicketStatusUpdateSuccess &&
            state.ticketId == widget.ticket.id &&
            !state.isLandlord) {
          _closeLoading(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.newStatus == TicketStatus.cancelled
                    ? 'Da huy yeu cau thanh cong.'
                    : 'Cap nhat ticket thanh cong.',
              ),
            ),
          );
          context.pop(true);
        } else if (state is TicketStatusUpdateError &&
            state.ticketId == widget.ticket.id &&
            !state.isLandlord) {
          _closeLoading(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [statusColor, statusColor.withValues(alpha: 0.75)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => context.pop(),
                        ),
                        const Expanded(
                          child: Text(
                            'Chi tiet su co',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${widget.ticket.id.substring(0, 8).toUpperCase()} · ${widget.ticket.category?.displayName ?? 'Khac'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                          ),
                          child: Text(
                            widget.ticket.status.displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.ticket.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, color: Colors.white70, size: 13),
                        const SizedBox(width: 5),
                        Text(
                          _formatTime(widget.ticket.createdAt),
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.place_rounded, color: Colors.white70, size: 13),
                        const SizedBox(width: 5),
                        Text(
                          widget.ticket.roomName ?? 'Phong hien tai',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.timeline_rounded, size: 18, color: cs.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Tien trinh xu ly',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          _TimelineStep(
                            icon: Icons.send_rounded,
                            color: Colors.green,
                            label: 'Da gui bao cao',
                            description: 'Yeu cau da duoc tao thanh cong',
                            time: _formatTime(widget.ticket.createdAt),
                            done: true,
                            cs: cs,
                          ),
                          _TimelineStep(
                            icon: Icons.engineering_rounded,
                            color: Colors.orange,
                            label: 'Dang xu ly',
                            description: widget.ticket.status == TicketStatus.pending
                                ? 'Cho chu nha tiep nhan'
                                : 'Chu nha dang xu ly ticket',
                            time: widget.ticket.status == TicketStatus.inProgress &&
                                    widget.ticket.updatedAt != null
                                ? _formatTime(widget.ticket.updatedAt!)
                                : '',
                            done: widget.ticket.status != TicketStatus.pending,
                            cs: cs,
                          ),
                          _TimelineStep(
                            icon: widget.ticket.status == TicketStatus.cancelled
                                ? Icons.block_rounded
                                : Icons.verified_rounded,
                            color: widget.ticket.status == TicketStatus.cancelled
                                ? Colors.grey
                                : Colors.green,
                            label: widget.ticket.status == TicketStatus.cancelled
                                ? 'Da huy'
                                : 'Hoan tat',
                            description: widget.ticket.status == TicketStatus.cancelled
                                ? 'Yeu cau da duoc huy'
                                : 'Su co da duoc giai quyet',
                            time: widget.ticket.status.isFinal && widget.ticket.updatedAt != null
                                ? _formatTime(widget.ticket.updatedAt!)
                                : '',
                            done: widget.ticket.status.isFinal,
                            cs: cs,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.description_rounded, size: 18, color: cs.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Mo ta su co',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Text(
                            widget.ticket.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: cs.onSurface.withValues(alpha: 0.75),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (widget.ticket.status == TicketStatus.pending)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _cancelTicket,
                              icon: const Icon(Icons.close_rounded, size: 16),
                              label: const Text('Huy yeu cau'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => context.push('/tenant/chat'),
                              icon: const Icon(Icons.chat_rounded, size: 16, color: Colors.white),
                              label: const Text(
                                'Chat chu nha',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cs.primary,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (!widget.ticket.status.isFinal)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/tenant/chat'),
                          icon: const Icon(Icons.chat_rounded, size: 16, color: Colors.white),
                          label: const Text(
                            'Chat chu nha',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cancelTicket() {
    context.read<TicketCubit>().updateTicketStatus(
          widget.ticket.id,
          TicketStatus.cancelled,
          isLandlord: false,
        );
  }

  void _closeLoading(BuildContext context) {
    if (_isLoadingVisible) {
      Navigator.of(context, rootNavigator: true).pop();
      _isLoadingVisible = false;
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat('dd/MM/yyyy · HH:mm').format(time);
  }

  Color _statusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.pending:
        return Colors.orange;
      case TicketStatus.inProgress:
        return Colors.blue;
      case TicketStatus.resolved:
        return Colors.green;
      case TicketStatus.cancelled:
        return Colors.grey;
    }
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String description;
  final String time;
  final bool done;
  final bool isLast;
  final ColorScheme cs;

  const _TimelineStep({
    required this.icon,
    required this.color,
    required this.label,
    required this.description,
    required this.time,
    required this.done,
    required this.cs,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, size: 22, color: done ? color : cs.onSurface.withValues(alpha: 0.25)),
            if (!isLast)
              Container(
                width: 2,
                height: 42,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: done
                      ? cs.primary.withValues(alpha: 0.25)
                      : cs.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: done ? cs.onSurface : cs.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                if (done) ...[
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.6)),
                  ),
                  if (time.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: TextStyle(fontSize: 10, color: cs.onSurface.withValues(alpha: 0.4)),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
