// lib/features/room/presentation/cubit/room_detail_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/room_repository.dart';
import '../../../invoice/domain/entities/invoice.dart';
import '../../../invoice/domain/repositories/invoice_repository.dart';
import '../../../meter_reading/domain/entities/meter_reading.dart';
import '../../../meter_reading/domain/repositories/meter_reading_repository.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../../../inventory/domain/repositories/inventory_repository.dart';
import '../../../ticket/domain/entities/ticket.dart';
import '../../../ticket/domain/repositories/ticket_repository.dart';
import 'room_detail_state.dart';

class RoomDetailCubit extends Cubit<RoomDetailState> {
  final RoomRepository _roomRepository;
  final InvoiceRepository _invoiceRepository;
  final MeterReadingRepository _meterReadingRepository;
  final InventoryRepository _inventoryRepository;
  final TicketRepository _ticketRepository;

  RoomDetailCubit({
    required RoomRepository roomRepository,
    required InvoiceRepository invoiceRepository,
    required MeterReadingRepository meterReadingRepository,
    required InventoryRepository inventoryRepository,
    required TicketRepository ticketRepository,
  }) : _roomRepository = roomRepository,
       _invoiceRepository = invoiceRepository,
       _meterReadingRepository = meterReadingRepository,
       _inventoryRepository = inventoryRepository,
       _ticketRepository = ticketRepository,
       super(RoomDetailState.initial());

  Future<void> loadRoomDetail(String roomId) async {
    emit(RoomDetailState.loading());

    try {
      // Step 1: Load room detail (contains contractId)
      final roomDetail = await _roomRepository.getRoomDetail(roomId);
      final contractId = roomDetail.contract?.id;

      // Step 2: Load remaining data in parallel
      final results = await Future.wait<List<dynamic>>([
        (contractId != null && roomDetail.invoices.isEmpty)
            ? _invoiceRepository.getInvoicesByContract(contractId)
            : Future<List<dynamic>>.value([]),
        _meterReadingRepository.getMeterReadingsByRoom(roomId),
        contractId != null
            ? _inventoryRepository.getInventoryByContract(contractId)
            : Future<List<dynamic>>.value([]),
        _ticketRepository.getLandlordTickets(),
      ]);

      // Use invoices from RoomDetail if available, otherwise from repository fetch
      final invoices = roomDetail.invoices.isNotEmpty
          ? roomDetail.invoices
          : results[0].cast<Invoice>();
      final meterReadings = results[1].cast<MeterReading>();
      final inventoryItems = results[2].cast<InventoryItem>();
      final allTickets = results[3].cast<Ticket>();

      // Filter tickets by roomId
      final roomTickets = allTickets.where((t) => t.roomId == roomId).toList();

      emit(
        RoomDetailState.loaded(
          roomDetail: roomDetail,
          invoices: invoices,
          meterReadings: meterReadings,
          inventoryItems: inventoryItems,
          tickets: roomTickets,
        ),
      );
    } catch (e, stackTrace) {
      print('❌ ERROR: $e');
      print('📍 STACK TRACE: $stackTrace');
      emit(RoomDetailState.error(message: e.toString()));
    }
  }

  void refresh(String roomId) => loadRoomDetail(roomId);

  Future<void> deleteRoom(String roomId) async {
    emit(RoomDetailState.deleteLoading());
    try {
      await _roomRepository.deleteRoom(roomId);
      emit(RoomDetailState.deleteSuccess());
    } catch (e) {
      emit(RoomDetailState.deleteError(message: e.toString()));
    }
  }
}
