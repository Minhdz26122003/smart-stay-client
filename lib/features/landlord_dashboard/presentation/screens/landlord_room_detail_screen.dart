// lib/features/landlord_dashboard/presentation/screens/landlord_room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smart_stay_client/features/meter_reading/domain/entities/meter_reading.dart';
import 'package:smart_stay_client/features/room/domain/entities/room_detail.dart';

import '../../../../core/di/injection_container.dart';
import '../../../room/presentation/cubit/room_detail_cubit.dart';
import '../../../room/presentation/cubit/room_detail_state.dart';
import '../../../invoice/domain/entities/invoice.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../../../ticket/domain/entities/ticket.dart';
import '../../../ticket/domain/entities/ticket_extensions.dart';
import '../../../room/domain/entities/room.dart';

final _vnd = NumberFormat('#,###', 'vi_VN');
String _formatVnd(double amount) => '${_vnd.format(amount)} đ';

class _LoadedData {
  final RoomDetail roomDetail;
  final List<Invoice> invoices;
  final List<MeterReading> meterReadings;
  final List<InventoryItem> inventoryItems;
  final List<Ticket> tickets;
  _LoadedData({
    required this.roomDetail,
    required this.invoices,
    required this.meterReadings,
    required this.inventoryItems,
    required this.tickets,
  });
}

class LandlordRoomDetailScreen extends StatelessWidget {
  final String roomId;
  const LandlordRoomDetailScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RoomDetailCubit>()..loadRoomDetail(roomId),
      child: _RoomDetailView(roomId: roomId),
    );
  }
}

class _RoomDetailView extends StatefulWidget {
  final String roomId;
  const _RoomDetailView({required this.roomId});

  @override
  State<_RoomDetailView> createState() => _RoomDetailViewState();
}

class _RoomDetailViewState extends State<_RoomDetailView> {
  int _tab = 0;
  bool _isDeleteLoadingVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return BlocConsumer<RoomDetailCubit, RoomDetailState>(
      listener: (context, state) {
        state.maybeWhen(
          deleteLoading: () {
            _isDeleteLoadingVisible = true;

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          },
          deleteSuccess: () {
            if (_isDeleteLoadingVisible) {
              Navigator.of(context, rootNavigator: true).pop();
              _isDeleteLoadingVisible = false;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Đã xóa phòng thành công")),
            );
            context.pop(true);
          },
          deleteError: (message) {
            if (_isDeleteLoadingVisible) {
              Navigator.of(context, rootNavigator: true).pop();
              _isDeleteLoadingVisible = false;
            }
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Loi: $message')));
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FF),
          body: CustomScrollView(
            slivers: [
              _buildHeader(context, cs, state),
              _buildTabBar(cs),
              ...state.when(
                initial: () => [
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
                loading: () => [
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
                loaded:
                    (
                      roomDetail,
                      invoices,
                      meterReadings,
                      inventoryItems,
                      tickets,
                    ) {
                      final data = _LoadedData(
                        roomDetail: roomDetail,
                        invoices: invoices,
                        meterReadings: meterReadings,
                        inventoryItems: inventoryItems,
                        tickets: tickets,
                      );
                      if (_tab == 0) {
                        return [_buildInfoTab(context, theme, cs, data, state)];
                      }
                      if (_tab == 1) {
                        return [_buildPaymentTab(context, theme, cs, state)];
                      }
                      if (_tab == 2) {
                        return [
                          _buildIssuesTab(context, theme, cs, data, state),
                        ];
                      }
                      if (_tab == 3) {
                        return [
                          _buildAssetsTab(context, theme, cs, data, state),
                        ];
                      }
                      return [const SliverToBoxAdapter(child: SizedBox())];
                    },
                error: (message) => [
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Lỗi tải dữ liệu',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(message, style: theme.textTheme.bodySmall),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => context
                                .read<RoomDetailCubit>()
                                .loadRoomDetail(widget.roomId),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                deleteLoading: () => [
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
                deleteSuccess: () => [
                  const SliverFillRemaining(
                    child: Center(child: Text('Đã xóa')),
                  ),
                ],
                deleteError: (message) => [
                  SliverFillRemaining(
                    child: Center(child: Text('Lỗi: $message')),
                  ),
                ],
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context, cs, state),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HEADER

  Widget _buildHeader(
    BuildContext context,
    ColorScheme cs,
    RoomDetailState state,
  ) {
    String title = 'Chi tiết phòng';
    String subtitle = '';
    String statusLabel = '...';
    bool isOccupied = false;

    state.maybeWhen(
      loaded: (roomDetail, invoices, meterReadings, inventoryItems, tickets) {
        final room = roomDetail.room;
        title = 'Phòng ${room.name}';
        subtitle =
            '${_formatVnd(room.basePrice)}/tháng · ${room.areaM2.toStringAsFixed(0)}m²';
        isOccupied = room.status == RoomStatus.occupied;

        if (isOccupied) {
          statusLabel = 'Đang thuê';
        } else if (room.status == RoomStatus.reserved) {
          statusLabel = 'Đã cọc';
        } else if (room.status == RoomStatus.underRepair) {
          statusLabel = 'Đang sửa chữa';
        } else {
          statusLabel = 'Trống';
        }
      },
      orElse: () {},
    );

    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: cs.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          onPressed: () =>
              context.read<RoomDetailCubit>().loadRoomDetail(widget.roomId),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
          onPressed: () {
            state.maybeWhen(
              loaded:
                  (
                    roomDetail,
                    invoices,
                    meterReadings,
                    inventoryItems,
                    tickets,
                  ) {
                    if (roomDetail.room.status == RoomStatus.occupied) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Không thể xóa phòng đang có người ở'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    } else {
                      _showDeleteConfirmationDialog(context);
                    }
                  },
              orElse: () {},
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cs.primary, cs.primary.withValues(alpha: 0.85)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: (isOccupied ? Colors.green : Colors.orange)
                              .withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (isOccupied ? Colors.green : Colors.orange)
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          statusLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TAB BAR

  Widget _buildTabBar(ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['Thông tin', 'Thanh toán', 'Sự cố', 'Tài sản']
                .asMap()
                .entries
                .map(
                  (e) => GestureDetector(
                    onTap: () => setState(() => _tab = e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _tab == e.key
                                ? cs.primary
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                      ),
                      child: Text(
                        e.value,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _tab == e.key
                              ? cs.primary
                              : cs.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TAB 0: THÔNG TIN

  Widget _buildInfoTab(
    BuildContext context,
    ThemeData theme,
    ColorScheme cs,
    _LoadedData data,
    RoomDetailState state,
  ) {
    final rd = data.roomDetail; // ← Sửa từ roomDetail thành data.roomDetail
    final tenant = rd.tenant;
    final contract = rd.contract;
    final elec = state.latestElectricity; // ← Giữ nguyên
    final water = state.latestWater;

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            // Tenant card
            _SectionCard(
              title: 'Người thuê',
              icon: Icons.person_outline,
              child:
                  (tenant == null ||
                      data.roomDetail.room.status != RoomStatus.occupied)
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          data.roomDetail.room.status == RoomStatus.occupied
                              ? 'Lỗi dữ liệu: Chưa có thông tin người thuê/hợp đồng'
                              : 'Phòng đang trống',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: cs.primaryContainer,
                              child: Text(
                                tenant.initials,
                                style: TextStyle(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tenant.fullName,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    tenant.phone,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: cs.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.phone_rounded,
                                color: cs.primary,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        if (contract != null) ...[
                          const Divider(height: 24),
                          _InfoRow(
                            icon: Icons.assignment_rounded,
                            label: 'Hợp đồng',
                            value: contract.dateRangeLabel,
                          ),
                          const SizedBox(height: 10),
                          _InfoRow(
                            icon: Icons.attach_money_rounded,
                            label: 'Tiền đặt cọc',
                            value: _formatVnd(contract.depositAmount),
                          ),
                          const SizedBox(height: 10),
                          _InfoRow(
                            icon: Icons.schedule_rounded,
                            label: 'Còn lại',
                            value: '${contract.remainingMonths} tháng',
                            valueColor: contract.remainingMonths < 2
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ],
                      ],
                    ),
            ),
            const SizedBox(height: 14),

            // Meter readings
            _SectionCard(
              title: 'Chỉ số tháng gần nhất',
              icon: Icons.bolt_rounded,
              child: elec == null && water == null
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Chưa có chỉ số',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        if (elec != null)
                          Expanded(
                            child: _UtilityCard(
                              icon: Icons.electric_bolt_rounded,
                              label: 'Điện',
                              period: elec.periodLabel,
                              previous: elec.oldUnit.toString(),
                              current: elec.newUnit.toString(),
                              usage: '${elec.consumed} kWh',
                              color: Colors.amber,
                            ),
                          ),
                        if (elec != null && water != null)
                          const SizedBox(width: 12),
                        if (water != null)
                          Expanded(
                            child: _UtilityCard(
                              icon: Icons.water_drop_rounded,
                              label: 'Nước',
                              period: water.periodLabel,
                              previous: water.oldUnit.toString(),
                              current: water.newUnit.toString(),
                              usage: '${water.consumed} m³',
                              color: Colors.blue,
                            ),
                          ),
                      ],
                    ),
            ),

            const SizedBox(height: 14),

            // Room info
            _SectionCard(
              title: 'Thông tin phòng',
              icon: Icons.door_sliding_outlined,
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.straighten_rounded,
                    label: 'Diện tích',
                    value:
                        '${data.roomDetail.room.areaM2.toStringAsFixed(0)} m²',
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.people_outline,
                    label: 'Số người tối đa',
                    value: '${data.roomDetail.room.maxOccupants} người',
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.star_outline_rounded,
                    label: 'Loại phòng',
                    value: data.roomDetail.room.type,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.price_change_outlined,
                    label: 'Giá thuê',
                    value: _formatVnd(data.roomDetail.room.basePrice),
                    valueColor: cs.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TAB 1: THANH TOÁN

  Widget _buildPaymentTab(
    BuildContext context,
    ThemeData theme,
    ColorScheme cs,
    RoomDetailState state,
  ) {
    final invoices = state.sortedInvoices;

    if (invoices.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyState(
          icon: Icons.receipt_long_outlined,
          message: 'Chưa có hóa đơn nào',
        ),
      );
    }

    // Summary stats
    final unpaid = invoices.where((i) => !i.isPaid).toList();
    final totalUnpaid = unpaid.fold(0.0, (s, i) => s + i.totalAmount);

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Summary banner if has unpaid
          if (unpaid.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade700, Colors.orange.shade500],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chưa thanh toán',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          _formatVnd(totalUnpaid),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${unpaid.length} hóa đơn',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          ...invoices.map(
            (invoice) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _InvoiceCard(invoice: invoice, cs: cs, theme: theme),
            ),
          ),
        ]),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TAB 2: SỰ CỐ

  Widget _buildIssuesTab(
    BuildContext context,
    ThemeData theme,
    ColorScheme cs,
    _LoadedData data,
    RoomDetailState state,
  ) {
    final openTickets = state.openTickets;
    final resolvedTickets = state.resolvedTickets;

    if (data.tickets.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyState(
          icon: Icons.check_circle_outline_rounded,
          message: 'Không có sự cố nào',
          subtitle: 'Phòng đang hoạt động bình thường',
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          if (openTickets.isNotEmpty) ...[
            _SectionHeader(title: 'Đang xử lý (${openTickets.length})'),
            ...openTickets.map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TicketCard(ticket: t, theme: theme, cs: cs),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (resolvedTickets.isNotEmpty) ...[
            _SectionHeader(title: 'Đã giải quyết (${resolvedTickets.length})'),
            ...resolvedTickets.map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TicketCard(ticket: t, theme: theme, cs: cs),
              ),
            ),
          ],
          TextButton.icon(
            onPressed: () => context.push('/landlord/operations/issues'),
            icon: Icon(Icons.open_in_new_rounded, size: 16, color: cs.primary),
            label: Text(
              'Xem toàn bộ lịch sử',
              style: TextStyle(color: cs.primary),
            ),
          ),
        ]),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TAB 3: TÀI SẢN

  Widget _buildAssetsTab(
    BuildContext context,
    ThemeData theme,
    ColorScheme cs,
    _LoadedData data,
    RoomDetailState state,
  ) {
    final items = data.inventoryItems;

    if (items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyState(
          icon: Icons.inventory_2_outlined,
          message: 'Chưa có danh sách tài sản',
          subtitle: 'Tài sản sẽ được ghi nhận khi lập hợp đồng',
        ),
      );
    }

    final goodItems = items
        .where((i) => i.condition == ItemCondition.good)
        .length;
    final damagedItems = items
        .where((i) => i.condition != ItemCondition.good)
        .length;

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Summary row
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AssetStat(
                  value: '${items.length}',
                  label: 'Tổng',
                  color: cs.primary,
                ),
                const SizedBox(width: 12),
                _AssetStat(
                  value: '$goodItems',
                  label: 'Tốt',
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                _AssetStat(
                  value: '$damagedItems',
                  label: 'Hư hỏng',
                  color: Colors.orange,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Danh sách bàn giao (${items.length} món)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                ...items.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: cs.primaryContainer.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${e.key + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            e.value.itemName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: e.value.condition == ItemCondition.good
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            e.value.condition.displayName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: e.value.condition == ItemCondition.good
                                  ? Colors.green.shade700
                                  : Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BOTTOM BAR

  Widget _buildBottomBar(
    BuildContext context,
    ColorScheme cs,
    RoomDetailState state,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      color: Colors.white,
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () => context.push('/landlord/chat'),
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
            label: const Text('Nhắn tin'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () =>
                  context.push('/landlord/operations/invoice-settle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Chốt hóa đơn',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận xóa?'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa phòng này? Dữ liệu sẽ bị xóa vĩnh viễn và không thể khôi phục.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<RoomDetailCubit>().deleteRoom(widget.roomId);
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED COMPONENTS

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      width: double.infinity,
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
              Icon(icon, size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color? valueColor;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: cs.onSurface.withValues(alpha: 0.35)),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: cs.onSurface.withValues(alpha: 0.55),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? cs.onSurface,
          ),
        ),
      ],
    );
  }
}

class _UtilityCard extends StatelessWidget {
  final IconData icon;
  final String label, period, previous, current, usage;
  final Color color;
  const _UtilityCard({
    required this.icon,
    required this.label,
    required this.period,
    required this.previous,
    required this.current,
    required this.usage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const Spacer(),
              Text(
                period,
                style: TextStyle(
                  fontSize: 10,
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            current,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          Text(
            'Trước: $previous',
            style: TextStyle(
              fontSize: 10,
              color: cs.onSurface.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              usage,
              style: TextStyle(
                fontSize: 11,
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

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final ColorScheme cs;
  final ThemeData theme;
  const _InvoiceCard({
    required this.invoice,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = invoice.isPaid;
    final isOverdue = invoice.status == InvoiceStatus.overdue;
    final Color statusColor = isPaid
        ? Colors.green
        : isOverdue
        ? Colors.red
        : Colors.orange;

    return GestureDetector(
      onTap: () {
        context.push('/landlord/finance/invoice-detail', extra: invoice);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: !isPaid
              ? Border(left: BorderSide(color: statusColor, width: 3))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isPaid ? Icons.check_circle_rounded : Icons.schedule_rounded,
                  color: statusColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    invoice.periodLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatVnd(invoice.totalAmount),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isPaid ? cs.onSurface : statusColor,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      invoice.status.displayName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Breakdown details
            if (invoice.breakdown != null) ...[
              const Divider(height: 16),
              _BreakdownRow(
                label: 'Tiền phòng',
                value: _formatVnd(invoice.breakdown!.rent),
              ),
              _BreakdownRow(
                label: 'Điện (${invoice.breakdown!.electricityConsumed} kWh)',
                value: _formatVnd(invoice.breakdown!.electricityAmount),
              ),
              _BreakdownRow(
                label: 'Nước (${invoice.breakdown!.waterConsumed} m³)',
                value: _formatVnd(invoice.breakdown!.waterAmount),
              ),
              if (invoice.breakdown!.internet > 0)
                _BreakdownRow(
                  label: 'Internet',
                  value: _formatVnd(invoice.breakdown!.internet),
                ),
              if (invoice.breakdown!.garbage > 0)
                _BreakdownRow(
                  label: 'Rác',
                  value: _formatVnd(invoice.breakdown!.garbage),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label, value;
  const _BreakdownRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurface.withValues(alpha: 0.55),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final Ticket ticket;
  final ThemeData theme;
  final ColorScheme cs;
  const _TicketCard({
    required this.ticket,
    required this.theme,
    required this.cs,
  });

  Color get _statusColor {
    switch (ticket.status) {
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

  Color get _priorityColor {
    switch (ticket.priority) {
      case TicketPriority.low:
        return Colors.green;
      case TicketPriority.medium:
        return Colors.orange;
      case TicketPriority.high:
      case TicketPriority.urgent:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: _statusColor, width: 3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.engineering_rounded,
              size: 16,
              color: _statusColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  ticket.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ticket.status.displayName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _statusColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ticket.priority!.displayName,
                  style: TextStyle(
                    fontSize: 9,
                    color: _priorityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _AssetStat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subtitle;
  const _EmptyState({required this.icon, required this.message, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: cs.onSurface.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: 0.35),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
