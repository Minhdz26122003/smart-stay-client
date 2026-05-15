import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket.freezed.dart';
part 'ticket.g.dart';

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
        return 'Điện';
      case TicketCategory.water:
        return 'Nước';
      case TicketCategory.furniture:
        return 'Nội thất';
      case TicketCategory.other:
        return 'Khác';
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
        return 'Thấp';
      case TicketPriority.medium:
        return 'Trung bình';
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
