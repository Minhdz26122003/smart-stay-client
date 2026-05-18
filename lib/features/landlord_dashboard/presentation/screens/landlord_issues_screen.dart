import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../ticket/presentation/bloc/ticket_cubit.dart';
import '../../../ticket/presentation/bloc/ticket_state.dart';
import '../../../ticket/domain/entities/ticket.dart';
import '../../../property/presentation/cubit/property_cubit.dart';
import '../../../property/presentation/cubit/property_state.dart';
import '../../../room/presentation/cubit/room_cubit.dart';
import '../../../room/presentation/cubit/room_state.dart';
import '../../../room/domain/entities/room.dart';

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

class LandlordIssuesScreen extends StatefulWidget {
  const LandlordIssuesScreen({super.key});

  @override
  State<LandlordIssuesScreen> createState() => _LandlordIssuesScreenState();
}

class _LandlordIssuesScreenState extends State<LandlordIssuesScreen> {
  String _filter = 'Tat ca';

  @override
  void initState() {
    super.initState();
    context.read<TicketCubit>().loadLandlordTickets();
    _loadRoomsForSelectedProperty();
  }

  void _loadRoomsForSelectedProperty() {
    final propertyState = context.read<PropertyCubit>().state;
    propertyState.maybeWhen(
      loaded: (_, selectedProperty) {
        if (selectedProperty != null) {
          context.read<RoomCubit>().loadRooms(selectedProperty.id);
        }
      },
      orElse: () {},
    );
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
        title: Text(
          'Quản lý sụ cố',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocListener<PropertyCubit, PropertyState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: (_, selectedProperty) {
              if (selectedProperty != null) {
                context.read<RoomCubit>().loadRooms(selectedProperty.id);
              }
            },
            orElse: () {},
          );
        },
        child: BlocBuilder<RoomCubit, RoomState>(
          builder: (context, roomState) {
            final rooms = roomState.maybeWhen(
              loaded: (value) => value,
              orElse: () => <Room>[],
            );

            return BlocBuilder<TicketCubit, TicketState>(
              builder: (context, state) {
                if (state is TicketLoading || state is TicketInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TicketError) {
                  return Center(child: Text(state.message));
                }

                final tickets = state is TicketLoaded
                    ? state.tickets
                    : <Ticket>[];
                final pendingCount = tickets
                    .where((ticket) => ticket.status == TicketStatus.pending)
                    .length;
                final inProgressCount = tickets
                    .where((ticket) => ticket.status == TicketStatus.inProgress)
                    .length;
                final resolvedCount = tickets
                    .where((ticket) => ticket.status == TicketStatus.resolved)
                    .length;
                final cancelledCount = tickets
                    .where((ticket) => ticket.status == TicketStatus.cancelled)
                    .length;

                final filteredTickets = tickets.where((ticket) {
                  if (_filter == 'Tất cả') return true;
                  return ticket.status.displayName == _filter;
                }).toList();

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
                            child: Text(
                              'Tổng cộng ${tickets.length} sự cố',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _StatChip(
                                  label: 'Chờ tiếp nhận',
                                  count: pendingCount,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                _StatChip(
                                  label: 'Đang xử lý',
                                  count: inProgressCount,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                _StatChip(
                                  label: 'Đã xử lý',
                                  count: resolvedCount,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                _StatChip(
                                  label: 'Đã hủy',
                                  count: cancelledCount,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  [
                                        'Tất cả',
                                        TicketStatus.pending.displayName,
                                        TicketStatus.inProgress.displayName,
                                        TicketStatus.resolved.displayName,
                                        TicketStatus.cancelled.displayName,
                                      ]
                                      .map(
                                        (filter) => Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                            bottom: 12,
                                          ),
                                          child: GestureDetector(
                                            onTap: () => setState(
                                              () => _filter = filter,
                                            ),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 180,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 7,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _filter == filter
                                                    ? cs.primary
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: _filter == filter
                                                      ? cs.primary
                                                      : cs.onSurface.withValues(
                                                          alpha: 0.15,
                                                        ),
                                                ),
                                              ),
                                              child: Text(
                                                filter,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: _filter == filter
                                                      ? Colors.white
                                                      : cs.onSurface.withValues(
                                                          alpha: 0.6,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: filteredTickets.isEmpty
                          ? Center(
                              child: Text(
                                'Không có sự cố phù hợp.',
                                style: TextStyle(
                                  color: cs.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredTickets.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final issue = filteredTickets[index];
                                final foundRoom = rooms
                                    .where((room) => room.id == issue.roomId)
                                    .cast<Room?>()
                                    .firstWhere(
                                      (room) => room != null,
                                      orElse: () => null,
                                    );
                                final mappedRoomName =
                                    issue.roomName ??
                                    foundRoom?.name ??
                                    'Phòng ?';

                                return GestureDetector(
                                  onTap: () => context.push(
                                    '/landlord/operations/issue-detail',
                                    extra: issue.copyWith(
                                      roomName: mappedRoomName,
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: issue.status.color
                                                .withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.engineering_rounded,
                                            size: 18,
                                            color: issue.status.color,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                mappedRoomName,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: cs.primary,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                issue.title,
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                issue.tenantName ??
                                                    'Người thuê',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      color: cs.onSurface
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
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
                                            color: issue.status.color
                                                .withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            issue.status.displayName,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: issue.status.color,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
