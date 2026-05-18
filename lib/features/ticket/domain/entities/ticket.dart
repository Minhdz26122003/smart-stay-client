import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket.freezed.dart';
part 'ticket.g.dart';

enum TicketStatus {
  @JsonValue('Pending')
  pending,
  @JsonValue('InProgress')
  inProgress,
  @JsonValue('Resolved')
  resolved,
  @JsonValue('Cancelled')
  cancelled;

  String get displayName {
    switch (this) {
      case TicketStatus.pending:
        return 'Cho tiep nhan';
      case TicketStatus.inProgress:
        return 'Dang xu ly';
      case TicketStatus.resolved:
        return 'Da xu ly';
      case TicketStatus.cancelled:
        return 'Da huy';
    }
  }

  bool get isFinal =>
      this == TicketStatus.resolved || this == TicketStatus.cancelled;
}

@JsonEnum(alwaysCreate: true)
enum TicketCategory {
  @JsonValue('Electricity')
  electricity,
  @JsonValue('Water')
  water,
  @JsonValue('Furniture')
  furniture,
  @JsonValue('Other')
  other;

  String get displayName {
    switch (this) {
      case TicketCategory.electricity:
        return 'Dien';
      case TicketCategory.water:
        return 'Nuoc';
      case TicketCategory.furniture:
        return 'Noi that';
      case TicketCategory.other:
        return 'Khac';
    }
  }
}

@JsonEnum(alwaysCreate: true)
enum TicketPriority {
  @JsonValue('Low')
  low,
  @JsonValue('Medium')
  medium,
  @JsonValue('High')
  high,
  @JsonValue('Urgent')
  urgent;

  String get displayName {
    switch (this) {
      case TicketPriority.low:
        return 'Thap';
      case TicketPriority.medium:
        return 'Trung binh';
      case TicketPriority.high:
      case TicketPriority.urgent:
        return 'Cao';
    }
  }
}

@freezed
abstract class Ticket with _$Ticket {
  const factory Ticket({
    required String id,
    String? propertyId,
    required String roomId,
    required String tenantId,
    String? tenantName,
    String? roomName,
    TicketCategory? category,
    TicketPriority? priority,
    required String title,
    required String description,
    required TicketStatus status,
    List<String>? photoUrls,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Ticket;
}
