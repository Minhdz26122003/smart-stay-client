import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../room/presentation/cubit/room_cubit.dart';
import '../../../room/presentation/cubit/room_state.dart';
import '../../../room/domain/entities/room.dart';

class LandlordRoomsScreen extends StatefulWidget {
  const LandlordRoomsScreen({super.key});
  @override
  State<LandlordRoomsScreen> createState() => _LandlordRoomsScreenState();
}

class _LandlordRoomsScreenState extends State<LandlordRoomsScreen> {
  String _filter = 'Tất cả';

  String _mapStatusToLabel(RoomStatus status) {
    switch (status) {
      case RoomStatus.occupied:
        return 'Đang thuê';
      case RoomStatus.available:
        return 'Trống';
      case RoomStatus.underRepair:
        return 'Sửa chữa';
      case RoomStatus.reserved:
        return 'Đã cọc';
    }
  }

  Color _mapStatusToColor(RoomStatus status, ColorScheme cs) {
    switch (status) {
      case RoomStatus.occupied:
        return cs.primary;
      case RoomStatus.available:
        return Colors.green;
      case RoomStatus.underRepair:
        return Colors.orange;
      case RoomStatus.reserved:
        return Colors.purple;
    }
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} đ';
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
          'Quản lý phòng',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<RoomCubit, RoomState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (rooms) {
              final filteredRooms = _filter == 'Tất cả'
                  ? rooms
                  : rooms.where((r) => _mapStatusToLabel(r.status) == _filter).toList();

              final occupied = rooms.where((r) => r.status == RoomStatus.occupied).length;
              final empty = rooms.where((r) => r.status == RoomStatus.available).length;
              final repair = rooms.where((r) => r.status == RoomStatus.underRepair).length;
              final reserved = rooms.where((r) => r.status == RoomStatus.reserved).length;

              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _StatChip(
                              count: occupied,
                              label: 'Đang thuê',
                              color: cs.primary,
                            ),
                            const SizedBox(width: 8),
                            _StatChip(count: empty, label: 'Trống', color: Colors.green),
                            const SizedBox(width: 8),
                            _StatChip(count: reserved, label: 'Đã cọc', color: Colors.purple),
                            const SizedBox(width: 8),
                            _StatChip(count: repair, label: 'Sửa chữa', color: Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['Tất cả', 'Đang thuê', 'Trống', 'Đã cọc', 'Sửa chữa']
                                .map(
                                  (f) => Padding(
                                    padding: const EdgeInsets.only(right: 8, bottom: 12),
                                    child: GestureDetector(
                                      onTap: () => setState(() => _filter = f),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 180),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: _filter == f ? cs.primary : Colors.transparent,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: _filter == f ? cs.primary : cs.onSurface.withValues(alpha: 0.15),
                                          ),
                                        ),
                                        child: Text(
                                          f,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: _filter == f ? Colors.white : cs.onSurface.withValues(alpha: 0.6),
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
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredRooms.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, i) {
                        final room = filteredRooms[i];
                        final isEmpty = room.status == RoomStatus.available;
                        final color = _mapStatusToColor(room.status, cs);
                        final label = _mapStatusToLabel(room.status);
                        
                        return GestureDetector(
                          onTap: () => context.push('/landlord/operations/room-detail', extra: room.id),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isEmpty ? Icons.door_front_door_outlined : Icons.king_bed_rounded,
                                    size: 22,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                room.name,
                                                style: theme.textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: color.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  label,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: color,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        room.type,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: cs.onSurface.withValues(alpha: 0.45),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (!isEmpty)
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person_outline,
                                              size: 13,
                                              color: cs.onSurface.withValues(alpha: 0.4),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Khách thuê (tối đa ${room.maxOccupants})',
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: cs.onSurface.withValues(alpha: 0.6),
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        Text(
                                          'Sẵn sàng đón khách mới',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: Colors.orange.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _formatPrice(room.basePrice),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: cs.primary,
                                      ),
                                    ),
                                  ],
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
            error: (msg) => Center(child: Text(msg)),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/landlord/operations/add-room'),
        extendedPadding: const EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: cs.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Thêm phòng',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _StatChip({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
                fontSize: 22,
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
      ),
    );
  }
}
