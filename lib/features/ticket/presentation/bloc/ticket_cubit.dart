import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/app_exception.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/ticket_repository.dart';
import 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  final TicketRepository _repository;

  TicketCubit({required TicketRepository repository})
      : _repository = repository,
        super(const TicketInitial());

  Future<void> loadLandlordTickets() async {
    emit(const TicketLoading());
    try {
      final tickets = await _repository.getLandlordTickets();
      emit(TicketLoaded(tickets: tickets));
    } catch (e) {
      emit(TicketError(message: _messageOf(e)));
    }
  }

  Future<void> loadTenantTickets() async {
    emit(const TicketLoading());
    try {
      final tickets = await _repository.getTenantTickets();
      emit(TicketLoaded(tickets: tickets));
    } catch (e) {
      emit(TicketError(message: _messageOf(e)));
    }
  }

  Future<void> createTicket({
    required String propertyId,
    required String roomId,
    required String title,
    required String description,
    required TicketCategory category,
    required TicketPriority priority,
  }) async {
    try {
      emit(const TicketSubmitting());
      final ticket = await _repository.createTicket(
        propertyId: propertyId,
        roomId: roomId,
        title: title,
        description: description,
        category: category,
        priority: priority,
      );
      emit(TicketSubmitSuccess(ticket: ticket));
      await loadTenantTickets();
    } catch (e) {
      emit(TicketSubmitError(message: _messageOf(e)));
    }
  }

  Future<void> updateTicketStatus(
    String id,
    TicketStatus newStatus, {
    bool isLandlord = true,
  }) async {
    final currentState = state;
    final currentTickets =
        currentState is TicketLoaded ? currentState.tickets : <Ticket>[];

    try {
      if (currentState is TicketLoaded) {
        emit(
          TicketStatusUpdating(
            tickets: currentState.tickets,
            ticketId: id,
            newStatus: newStatus,
            isLandlord: isLandlord,
          ),
        );
      }
      await _repository.updateTicketStatus(id, newStatus);
      emit(
        TicketStatusUpdateSuccess(
          ticketId: id,
          newStatus: newStatus,
          isLandlord: isLandlord,
        ),
      );
      if (isLandlord) {
        await loadLandlordTickets();
      } else {
        await loadTenantTickets();
      }
    } catch (e) {
      if (currentState is TicketLoaded) {
        emit(
          TicketStatusUpdateError(
            tickets: currentTickets,
            message: _messageOf(e),
            ticketId: id,
            newStatus: newStatus,
            isLandlord: isLandlord,
          ),
        );
        return;
      }
      emit(TicketError(message: _messageOf(e)));
    }
  }

  String _messageOf(Object error) =>
      error is AppException ? error.message : error.toString();
}
