// lib/features/room/presentation/cubit/room_detail_state.dart
import '../../domain/entities/room_detail.dart';
import '../../../invoice/domain/entities/invoice.dart';
import '../../../meter_reading/domain/entities/meter_reading.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../../../ticket/domain/entities/ticket.dart';

abstract class RoomDetailState {}

class RoomDetailInitial extends RoomDetailState {}

class RoomDetailLoading extends RoomDetailState {}

class RoomDetailLoaded extends RoomDetailState {
  final RoomDetail roomDetail;
  final List<Invoice> invoices;
  final List<MeterReading> meterReadings;
  final List<InventoryItem> inventoryItems;
  final List<Ticket> tickets;

  RoomDetailLoaded({
    required this.roomDetail,
    required this.invoices,
    required this.meterReadings,
    required this.inventoryItems,
    required this.tickets,
  });

  /// Latest meter readings (most recent month)
  MeterReading? get latestElectricity {
    final elec = meterReadings
        .where((r) => r.type == MeterType.electricity)
        .toList()
      ..sort((a, b) {
        final aKey = a.year * 100 + a.month;
        final bKey = b.year * 100 + b.month;
        return bKey.compareTo(aKey);
      });
    return elec.isNotEmpty ? elec.first : null;
  }

  MeterReading? get latestWater {
    final water = meterReadings
        .where((r) => r.type == MeterType.water)
        .toList()
      ..sort((a, b) {
        final aKey = a.year * 100 + a.month;
        final bKey = b.year * 100 + b.month;
        return bKey.compareTo(aKey);
      });
    return water.isNotEmpty ? water.first : null;
  }

  List<Invoice> get sortedInvoices {
    final list = [...invoices];
    list.sort((a, b) {
      final aKey = a.year * 100 + a.month;
      final bKey = b.year * 100 + b.month;
      return bKey.compareTo(aKey); // newest first
    });
    return list;
  }

  List<Ticket> get openTickets =>
      tickets.where((t) => t.status == TicketStatus.open || t.status == TicketStatus.inProgress).toList();

  List<Ticket> get resolvedTickets =>
      tickets.where((t) => t.status == TicketStatus.resolved || t.status == TicketStatus.closed).toList();
}

class RoomDetailError extends RoomDetailState {
  final String message;
  RoomDetailError(this.message);
}
