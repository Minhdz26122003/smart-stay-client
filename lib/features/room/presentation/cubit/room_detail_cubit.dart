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
  })  : _roomRepository = roomRepository,
        _invoiceRepository = invoiceRepository,
        _meterReadingRepository = meterReadingRepository,
        _inventoryRepository = inventoryRepository,
        _ticketRepository = ticketRepository,
        super(RoomDetailInitial());

  Future<void> loadRoomDetail(String roomId) async {
    emit(RoomDetailLoading());

    try {
      // Step 1: Load room detail (contains contractId)
      final roomDetail = await _roomRepository.getRoomDetail(roomId);
      final contractId = roomDetail.contract?.id;

      // Step 2: Load remaining data in parallel
      final results = await Future.wait<List<dynamic>>([
        contractId != null
            ? _invoiceRepository.getInvoicesByContract(contractId)
            : Future<List<dynamic>>.value([]),
        _meterReadingRepository.getMeterReadingsByRoom(roomId),
        contractId != null
            ? _inventoryRepository.getInventoryByContract(contractId)
            : Future<List<dynamic>>.value([]),
        _ticketRepository.getLandlordTickets(),
      ]);

      final invoices = results[0].cast<Invoice>();
      final meterReadings = results[1].cast<MeterReading>();
      final inventoryItems = results[2].cast<InventoryItem>();
      final allTickets = results[3].cast<Ticket>();

      // Filter tickets by roomId
      final roomTickets = allTickets.where((t) => t.roomId == roomId).toList();

      emit(RoomDetailLoaded(
        roomDetail: roomDetail,
        invoices: invoices,
        meterReadings: meterReadings,
        inventoryItems: inventoryItems,
        tickets: roomTickets,
      ));
    } catch (e) {
      emit(RoomDetailError(e.toString()));
    }
  }

  void refresh(String roomId) => loadRoomDetail(roomId);
}
