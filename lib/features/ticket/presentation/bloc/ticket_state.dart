import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ticket.dart';

part 'ticket_state.freezed.dart';

@freezed
class TicketState with _$TicketState {
  const factory TicketState.initial() = _Initial;
  const factory TicketState.loading() = _Loading;
  const factory TicketState.loaded({
    required List<Ticket> tickets,
  }) = _Loaded;
  const factory TicketState.error({required String message}) = _Error;
}
