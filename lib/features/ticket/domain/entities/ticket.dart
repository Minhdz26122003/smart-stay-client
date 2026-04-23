import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket.freezed.dart';

enum TicketStatus {
  @JsonValue('Open')
  open,
  @JsonValue('InProgress')
  inProgress,
  @JsonValue('Resolved')
  resolved,
  @JsonValue('Closed')
  closed;

  String get displayName {
    switch (this) {
      case TicketStatus.open:
        return 'Mới báo';
      case TicketStatus.inProgress:
        return 'Đang xử lý';
      case TicketStatus.resolved:
      case TicketStatus.closed:
        return 'Đã xử lý';
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
    int? category,
    int? priority,
    required String title,
    required String description,
    required TicketStatus status,
    List<String>? photoUrls,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Ticket;
}
