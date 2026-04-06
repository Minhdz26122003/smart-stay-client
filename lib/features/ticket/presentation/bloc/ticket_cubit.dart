import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/ticket_repository.dart';
import 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  final TicketRepository _repository;

  TicketCubit({required TicketRepository repository})
      : _repository = repository,
        super(const TicketState.initial());

  Future<void> loadLandlordTickets() async {
    emit(const TicketState.loading());
    try {
      final tickets = await _repository.getLandlordTickets();
      // Mặc định backend có thể không mock roomName, nhưng ta vẫn giữ nguyên
      emit(TicketState.loaded(tickets: tickets));
    } catch (e) {
      emit(TicketState.error(message: e.toString()));
    }
  }

  Future<void> loadTenantTickets() async {
    emit(const TicketState.loading());
    try {
      final tickets = await _repository.getTenantTickets();
      emit(TicketState.loaded(tickets: tickets));
    } catch (e) {
      emit(TicketState.error(message: e.toString()));
    }
  }

  Future<void> updateTicketStatus(String id, TicketStatus newStatus, {bool isLandlord = true}) async {
    try {
      await _repository.updateTicketStatus(id, newStatus);
      // Reload danh sách
      if (isLandlord) {
        await loadLandlordTickets();
      } else {
        await loadTenantTickets();
      }
    } catch (e) {
      // Ignored for now or could emit error
      emit(TicketState.error(message: e.toString()));
    }
  }
}
