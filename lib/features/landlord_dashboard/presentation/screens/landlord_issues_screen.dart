import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../ticket/presentation/bloc/ticket_cubit.dart';
import '../../../ticket/presentation/bloc/ticket_state.dart';
import '../../../ticket/domain/entities/ticket.dart';
import '../../../room/presentation/cubit/room_cubit.dart';
import '../../../room/presentation/cubit/room_state.dart';
import '../../../room/domain/entities/room.dart';

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
}

class LandlordIssuesScreen extends StatefulWidget {
  const LandlordIssuesScreen({super.key});
  @override
  State<LandlordIssuesScreen> createState() => _LandlordIssuesScreenState();
}

class _LandlordIssuesScreenState extends State<LandlordIssuesScreen> {
  String _filter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    context.read<TicketCubit>().loadLandlordTickets();
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return '${diff.inDays} ngày trước';
    if (diff.inHours > 0) return '${diff.inHours} giờ trước';
    if (diff.inMinutes > 0) return '${diff.inMinutes} phút trước';
    return 'Vừa xong';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: cs.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Quản lý sự cố',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: false,
      ),
      body: BlocBuilder<RoomCubit, RoomState>(
        builder: (context, roomState) {
          final rooms = roomState.maybeWhen(
            loaded: (r) => r,
            orElse: () => <Room>[],
          );
          
          return BlocBuilder<TicketCubit, TicketState>(
            builder: (context, state) {
              return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => Center(child: Text('Lỗi: $msg')),
            loaded: (tickets) {
              final newCount = tickets.where((i) => i.status == TicketStatus.open).length;
              final processingCount = tickets.where((i) => i.status == TicketStatus.inProgress).length;
              final doneCount = tickets.where((i) => i.status == TicketStatus.resolved || i.status == TicketStatus.closed).length;

              List<Ticket> filtered = tickets;
              if (_filter != 'Tất cả') {
                filtered = tickets.where((i) => i.status.displayName == _filter).toList();
              }

              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(children: [
                            const Icon(Icons.trending_up, size: 14, color: Colors.orange),
                            const SizedBox(width: 6),
                            Text('Tổng cộng: ${tickets.length} sự cố',
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.orange.shade700, fontWeight: FontWeight.w500)),
                          ]),
                        ),
                        const SizedBox(height: 12),
                        Row(children: [
                          _StatChip(label: 'Mới báo', count: newCount, color: Colors.red),
                          const SizedBox(width: 8),
                          _StatChip(label: 'Đang xử lý', count: processingCount, color: Colors.orange),
                          const SizedBox(width: 8),
                          _StatChip(label: 'Đã xử lý', count: doneCount, color: Colors.green),
                        ]),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['Tất cả', 'Mới báo', 'Đang xử lý', 'Đã xử lý']
                                .map((f) => Padding(
                                      padding: const EdgeInsets.only(right: 8, bottom: 12),
                                      child: GestureDetector(
                                        onTap: () => setState(() => _filter = f),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 180),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 7),
                                          decoration: BoxDecoration(
                                            color: _filter == f ? cs.primary : Colors.transparent,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: _filter == f
                                                  ? cs.primary
                                                  : cs.onSurface.withValues(alpha: 0.15),
                                            ),
                                          ),
                                          child: Text(f,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: _filter == f
                                                    ? Colors.white
                                                    : cs.onSurface.withValues(alpha: 0.6),
                                              )),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, i) {
                        final issue = filtered[i];
                        final statusColor = issue.status.color;
                        final isUrgent = false; // Mock for now
                        
                        final foundRoom = rooms.where((r) => r.id == issue.roomId).firstOrNull;
                        final mappedRoomName = issue.roomName ?? foundRoom?.name ?? '?';
                        
                        return GestureDetector(
                          onTap: () => context.push(
                            '/landlord/operations/issue-detail',
                            extra: issue, // Pass ticket object
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: isUrgent
                                  ? Border(left: BorderSide(color: Colors.red.shade400, width: 4))
                                  : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.engineering_rounded,
                                          size: 18, color: statusColor),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Text('Phòng $mappedRoomName',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: cs.primary)),
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: cs.primaryContainer.withValues(alpha: 0.4),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text('Kỹ thuật',
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color: cs.primary,
                                                      fontWeight: FontWeight.w600)),
                                            ),
                                          ]),
                                          const SizedBox(height: 2),
                                          Text(issue.title,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(issue.status.displayName,
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: statusColor)),
                                    ),
                                  ]),
                                  const SizedBox(height: 10),
                                  Row(children: [
                                    if (issue.tenantName != null && issue.tenantName!.isNotEmpty) ...[
                                      Icon(Icons.person_outline,
                                          size: 12, color: cs.onSurface.withValues(alpha: 0.4)),
                                      const SizedBox(width: 4),
                                      Text(issue.tenantName!,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                              color: cs.onSurface.withValues(alpha: 0.5))),
                                      const SizedBox(width: 12),
                                    ],
                                    Icon(Icons.schedule_rounded,
                                        size: 12, color: cs.onSurface.withValues(alpha: 0.4)),
                                    const SizedBox(width: 4),
                                    Text(_formatTimeAgo(issue.createdAt),
                                        style: theme.textTheme.bodySmall?.copyWith(
                                            color: cs.onSurface.withValues(alpha: 0.5))),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            orElse: () => const SizedBox.shrink(),
          );
        },
      );
    },
  ),
);
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatChip({required this.label, required this.count, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(children: [
            Text('$count',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            Text(label,
                style: TextStyle(fontSize: 9, color: color), textAlign: TextAlign.center),
          ]),
        ),
      );
}
