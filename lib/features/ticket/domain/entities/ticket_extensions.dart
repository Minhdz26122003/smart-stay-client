// lib/features/ticket/domain/entities/ticket_extensions.dart
// Helper extensions to avoid modifying the freezed entity

import 'ticket.dart';

enum TicketPriority {
  low,
  medium,
  high;

  static TicketPriority fromInt(int? v) {
    switch (v) {
      case 0:
        return TicketPriority.low;
      case 1:
        return TicketPriority.medium;
      case 2:
      case 3:
        return TicketPriority.high;
      default:
        return TicketPriority.low;
    }
  }

  String get displayName {
    switch (this) {
      case TicketPriority.low:
        return 'Thấp';
      case TicketPriority.medium:
        return 'Trung bình';
      case TicketPriority.high:
        return 'Cao';
    }
  }
}

extension TicketX on Ticket {
  TicketPriority get priorityEnum => TicketPriority.fromInt(priority);
}
