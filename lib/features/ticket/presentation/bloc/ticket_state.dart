import 'package:equatable/equatable.dart';
import '../../domain/entities/ticket.dart';

abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object?> get props => [];
}

class TicketInitial extends TicketState {
  const TicketInitial();
}

class TicketLoading extends TicketState {
  const TicketLoading();
}

class TicketLoaded extends TicketState {
  final List<Ticket> tickets;

  const TicketLoaded({required this.tickets});

  @override
  List<Object?> get props => [tickets];
}

class TicketError extends TicketState {
  final String message;

  const TicketError({required this.message});

  @override
  List<Object?> get props => [message];
}

class TicketSubmitting extends TicketState {
  const TicketSubmitting();
}

class TicketSubmitSuccess extends TicketState {
  final Ticket ticket;

  const TicketSubmitSuccess({required this.ticket});

  @override
  List<Object?> get props => [ticket];
}

class TicketSubmitError extends TicketState {
  final String message;

  const TicketSubmitError({required this.message});

  @override
  List<Object?> get props => [message];
}

class TicketStatusUpdating extends TicketLoaded {
  final String ticketId;
  final TicketStatus newStatus;
  final bool isLandlord;

  const TicketStatusUpdating({
    required super.tickets,
    required this.ticketId,
    required this.newStatus,
    required this.isLandlord,
  });

  @override
  List<Object?> get props => [...super.props, ticketId, newStatus, isLandlord];
}

class TicketStatusUpdateSuccess extends TicketState {
  final String ticketId;
  final TicketStatus newStatus;
  final bool isLandlord;

  const TicketStatusUpdateSuccess({
    required this.ticketId,
    required this.newStatus,
    required this.isLandlord,
  });

  @override
  List<Object?> get props => [ticketId, newStatus, isLandlord];
}

class TicketStatusUpdateError extends TicketLoaded {
  final String message;
  final String ticketId;
  final TicketStatus newStatus;
  final bool isLandlord;

  const TicketStatusUpdateError({
    required super.tickets,
    required this.message,
    required this.ticketId,
    required this.newStatus,
    required this.isLandlord,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        message,
        ticketId,
        newStatus,
        isLandlord,
      ];
}
