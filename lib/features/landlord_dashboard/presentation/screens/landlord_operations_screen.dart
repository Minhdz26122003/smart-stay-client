import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../room/presentation/cubit/room_cubit.dart';
import '../../../room/presentation/cubit/room_state.dart';
import '../../../property/presentation/cubit/property_cubit.dart';
import '../../../property/presentation/cubit/property_state.dart';
import '../../../room/domain/entities/room.dart';

class LandlordOperationsScreen extends StatefulWidget {
  const LandlordOperationsScreen({super.key});

  @override
  State<LandlordOperationsScreen> createState() =>
      _LandlordOperationsScreenState();
}

class _LandlordOperationsScreenState extends State<LandlordOperationsScreen> {
  @override
  void initState() {
    super.initState();
    final propState = context.read<PropertyCubit>().state;
    propState.maybeWhen(
      loaded: (props, selected) {
        if (selected != null) {
          context.read<RoomCubit>().loadRooms(selected.id);
        }
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: BlocListener<PropertyCubit, PropertyState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: (props, selected) {
              if (selected != null) {
                context.read<RoomCubit>().loadRooms(selected.id);
              }
            },
            orElse: () {},
          );
        },
        child: CustomScrollView(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vận hành',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),

                    // Quick Action Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.92,
                      children: [
                        _QuickAction(
                          icon: Icons.door_front_door_rounded,
                          label: 'Quản lý\nphòng',
                          badge: '26 phòng',
                          onTap: () =>
                              context.push('/landlord/operations/rooms'),
                        ),
                        _QuickAction(
                          icon: Icons.assignment_rounded,
                          label: 'Hợp\nđồng',
                          badge: 'Xem chi tiết',
                          onTap: () => context.push(
                            '/landlord/operations/create-contract',
                          ),
                        ),
                        _QuickAction(
                          icon: Icons.engineering_rounded,
                          label: 'Sự cố',
                          badge: 'Cần xử lý',
                          badgeColor: Colors.red,
                          onTap: () =>
                              context.push('/landlord/operations/issues'),
                        ),
                        _QuickAction(
                          icon: Icons.campaign_rounded,
                          label: 'Bảng tin',
                          badge: 'Đăng thông báo',
                          onTap: () =>
                              context.push('/landlord/operations/listings'),
                        ),
                        _QuickAction(
                          icon: Icons.people_alt_rounded,
                          label: 'Người\nthuê',
                          badge: '24 người',
                          onTap: () => {},
                        ),
                        _QuickAction(
                          icon: Icons.directions_car_rounded,
                          label: 'Xe &\nKhách',
                          badge: 'Đăng ký mới',
                          onTap: () => {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Room Status ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: BlocBuilder<RoomCubit, RoomState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    loaded: (rooms) {
                      final total = rooms.length;
                      final occupied = rooms
                          .where((r) => r.status == RoomStatus.occupied)
                          .length;
                      final empty = rooms
                          .where((r) => r.status == RoomStatus.available)
                          .length;
                      final repair = rooms
                          .where((r) => r.status == RoomStatus.underRepair)
                          .length;
                      final reserved = rooms
                          .where((r) => r.status == RoomStatus.reserved)
                          .length;

                      final totalCount = total == 0 ? 1 : total;
                      final flexOccupied = (occupied / totalCount * 100)
                          .toInt();
                      final flexEmpty = (empty / totalCount * 100).toInt();
                      final flexRepair = (repair / totalCount * 100).toInt();
                      final flexReserved = (reserved / totalCount * 100)
                          .toInt();

                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Trạng thái phòng',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Tổng $total phòng',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: cs.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 16,
                                runSpacing: 8,
                                children: [
                                  _RoomStatusDot(
                                    color: cs.primary,
                                    label: 'Đang thuê',
                                    count: occupied,
                                  ),
                                  _RoomStatusDot(
                                    color: Colors.green,
                                    label: 'Trống',
                                    count: empty,
                                  ),
                                  _RoomStatusDot(
                                    color: Colors.purple,
                                    label: 'Đã cọc',
                                    count: reserved,
                                  ),
                                  _RoomStatusDot(
                                    color: Colors.orange,
                                    label: 'Sửa chữa',
                                    count: repair,
                                  ),
                                ],
                              ),
                              if (total > 0) ...[
                                const SizedBox(height: 14),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Row(
                                    children: [
                                      if (flexOccupied > 0)
                                        Expanded(
                                          flex: flexOccupied,
                                          child: Container(
                                            height: 10,
                                            color: cs.primary,
                                          ),
                                        ),
                                      if (flexEmpty > 0)
                                        Expanded(
                                          flex: flexEmpty,
                                          child: Container(
                                            height: 10,
                                            color: Colors.green,
                                          ),
                                        ),
                                      if (flexReserved > 0)
                                        Expanded(
                                          flex: flexReserved,
                                          child: Container(
                                            height: 10,
                                            color: Colors.purple,
                                          ),
                                        ),
                                      if (flexRepair > 0)
                                        Expanded(
                                          flex: flexRepair,
                                          child: Container(
                                            height: 10,
                                            color: Colors.orange,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                    error: (msg) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(child: Text('Lỗi: $msg')),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
            ),

            // ── Issues Section ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.engineering_rounded,
                          color: Colors.orange.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sự cố cần xử lý',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () =>
                          context.push('/landlord/operations/issues'),
                      child: Text(
                        'Xem tất cả',
                        style: TextStyle(color: cs.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _IssueCard(
                    room: 'P.102',
                    issue: 'Điều hòa không mát',
                    tenant: 'Trần Thị Bình',
                    timeAgo: '3 giờ trước',
                    isUrgent: true,
                    onTap: () =>
                        context.push('/landlord/operations/issue-detail'),
                  ),
                  const SizedBox(height: 10),
                  _IssueCard(
                    room: 'P.305',
                    issue: 'Đèn hành lang tầng 3 hỏng',
                    tenant: 'Lê Văn D',
                    timeAgo: '1 ngày trước',
                    isUrgent: false,
                    onTap: () =>
                        context.push('/landlord/operations/issue-detail'),
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),

            // ── Contracts Section ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hợp đồng sắp hết hạn',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _ContractExpiryRow(
                    name: 'Lê Văn Cường',
                    expiryDate: '01/04',
                    daysLeft: 11,
                    isUrgent: true,
                  ),
                  const SizedBox(height: 8),
                  _ContractExpiryRow(
                    name: 'Trần Hoa',
                    expiryDate: '15/04',
                    daysLeft: 25,
                    isUrgent: false,
                  ),
                  const SizedBox(height: 8),
                  _ContractExpiryRow(
                    name: 'Nguyễn Thành',
                    expiryDate: '20/04',
                    daysLeft: 30,
                    isUrgent: false,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quick Action ─────────────────────────────────────────────────────────────

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label, badge;
  final Color? badgeColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.badge,
    required this.onTap,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: cs.primary, size: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  badge,
                  style: TextStyle(
                    fontSize: 9,
                    color: badgeColor ?? cs.onSurface.withValues(alpha: 0.5),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Room Status Dot ─────────────────────────────────────────────────────────

class _RoomStatusDot extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _RoomStatusDot({
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Issue Card ───────────────────────────────────────────────────────────────

class _IssueCard extends StatelessWidget {
  final String room, issue, tenant, timeAgo;
  final bool isUrgent;
  final VoidCallback onTap;

  const _IssueCard({
    required this.room,
    required this.issue,
    required this.tenant,
    required this.timeAgo,
    required this.isUrgent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return GestureDetector(
      onTap: onTap,
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          room,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isUrgent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Khẩn',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      issue,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 12,
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$tenant · $timeAgo',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Contract Expiry Row ──────────────────────────────────────────────────────

class _ContractExpiryRow extends StatelessWidget {
  final String name, expiryDate;
  final int daysLeft;
  final bool isUrgent;

  const _ContractExpiryRow({
    required this.name,
    required this.expiryDate,
    required this.daysLeft,
    required this.isUrgent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final color = isUrgent ? Colors.red : Colors.orange.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Hết hạn $expiryDate',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Còn $daysLeft ngày',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
