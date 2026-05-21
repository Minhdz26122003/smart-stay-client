// lib/features/room/presentation/cubit/room_detail_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/room_detail.dart';
import '../../../invoice/domain/entities/invoice.dart';
import '../../../meter_reading/domain/entities/meter_reading.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../../../ticket/domain/entities/ticket.dart';

// Dòng này BẮT BUỘC: Báo cho Freezed biết sẽ sinh file .freezed.dart
part 'room_detail_state.freezed.dart';

/// Annotation @freezed báo cho code generator biết đây là freezed class
@freezed
class RoomDetailState with _$RoomDetailState {
  /// Trạng thái ban đầu (khi chưa load gì)
  const factory RoomDetailState.initial() = _Initial;

  /// Đang tải dữ liệu phòng
  const factory RoomDetailState.loading() = _Loading;

  /// Đã tải xong dữ liệu phòng (chứa tất cả thông tin)
  const factory RoomDetailState.loaded({
    required RoomDetail roomDetail,
    required List<Invoice> invoices,
    required List<MeterReading> meterReadings,
    required List<InventoryItem> inventoryItems,
    required List<Ticket> tickets,
  }) = _Loaded;

  /// Lỗi khi tải dữ liệu
  const factory RoomDetailState.error({
    required String message,
  }) = _Error;

  /// Đang xóa phòng
  const factory RoomDetailState.deleteLoading() = _DeleteLoading;

  /// Xóa phòng thành công
  const factory RoomDetailState.deleteSuccess() = _DeleteSuccess;

  /// Lỗi khi xóa phòng
  const factory RoomDetailState.deleteError({
    required String message,
  }) = _DeleteError;
}

/// Extension để thêm các getter cho derived data (dữ liệu dẫn xuất)
/// Chỉ áp dụng cho state 'loaded'
extension RoomDetailStateX on RoomDetailState {
  /// Latest electricity meter reading
  MeterReading? get latestElectricity {
    return maybeWhen(
      loaded: (roomDetail, invoices, meterReadings, inventoryItems, tickets) {
        final elec = meterReadings
            .where((r) => r.type == MeterType.electricity)
            .toList()
          ..sort((a, b) {
            final aKey = a.year * 100 + a.month;
            final bKey = b.year * 100 + b.month;
            return bKey.compareTo(aKey);
          });
        return elec.isNotEmpty ? elec.first : null;
      },
      orElse: () => null,
    );
  }

  /// Latest water meter reading
  MeterReading? get latestWater {
    return maybeWhen(
      loaded: (roomDetail, invoices, meterReadings, inventoryItems, tickets) {
        final water = meterReadings
            .where((r) => r.type == MeterType.water)
            .toList()
          ..sort((a, b) {
            final aKey = a.year * 100 + a.month;
            final bKey = b.year * 100 + b.month;
            return bKey.compareTo(aKey);
          });
        return water.isNotEmpty ? water.first : null;
      },
      orElse: () => null,
    );
  }

  /// Sorted invoices (newest first)
  List<Invoice> get sortedInvoices {
    return maybeWhen(
      loaded: (roomDetail, invoices, meterReadings, inventoryItems, tickets) {
        final list = [...invoices];
        list.sort((a, b) {
          final aKey = a.year * 100 + a.month;
          final bKey = b.year * 100 + b.month;
          return bKey.compareTo(aKey);
        });
        return list;
      },
      orElse: () => [],
    );
  }

  /// Open tickets (pending or in progress)
  List<Ticket> get openTickets {
    return maybeWhen(
      loaded: (roomDetail, invoices, meterReadings, inventoryItems, tickets) {
        return tickets
            .where((t) =>
                t.status == TicketStatus.pending ||
                t.status == TicketStatus.inProgress)
            .toList();
      },
      orElse: () => [],
    );
  }

  /// Resolved tickets (resolved or cancelled)
  List<Ticket> get resolvedTickets {
    return maybeWhen(
      loaded: (roomDetail, invoices, meterReadings, inventoryItems, tickets) {
        return tickets
            .where((t) =>
                t.status == TicketStatus.resolved ||
                t.status == TicketStatus.cancelled)
            .toList();
      },
      orElse: () => [],
    );
  }
}
