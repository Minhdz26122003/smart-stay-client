import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ticket.dart';

part 'ticket_model.freezed.dart';
part 'ticket_model.g.dart';

@freezed
abstract class TicketModel with _$TicketModel {
  const TicketModel._();

  const factory TicketModel({
    required String id,
    String? propertyId,
    required String roomId,
    required String tenantId,
    String? tenantName,
    String? roomName,
    @JsonKey(unknownEnumValue: TicketCategory.other) TicketCategory? category,
    @JsonKey(unknownEnumValue: TicketPriority.low) TicketPriority? priority,
    required String title,
    required String description,
    @TicketStatusConverter() @Default(TicketStatus.open) TicketStatus status,
    List<String>? photoUrls,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TicketModel;

  factory TicketModel.fromJson(Map<String, dynamic> json) =>
      _$TicketModelFromJson(json);

  Ticket toEntity() => Ticket(
    id: id,
    propertyId: propertyId,
    roomId: roomId,
    tenantId: tenantId,
    tenantName: tenantName,
    roomName: roomName,
    category: category,
    priority: priority,
    title: title,
    description: description,
    status: status,
    photoUrls: photoUrls,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

class TicketStatusConverter implements JsonConverter<TicketStatus, dynamic> {
  const TicketStatusConverter();

  @override
  TicketStatus fromJson(dynamic json) {
    if (json == null) return TicketStatus.open;
    if (json is int) {
      switch (json) {
        case 0: return TicketStatus.open;
        case 1: return TicketStatus.inProgress;
        case 2: return TicketStatus.resolved;
        case 3: return TicketStatus.closed;
        default: return TicketStatus.open;
      }
    }
    if (json is String) {
      switch (json.toLowerCase()) {
        case 'open':
        case 'pending':
        case 'new': return TicketStatus.open;
        case 'inprogress':
        case 'in_progress':
        case 'processing': return TicketStatus.inProgress;
        case 'resolved':
        case 'done': return TicketStatus.resolved;
        case 'closed': return TicketStatus.closed;
        default: return TicketStatus.open;
      }
    }
    return TicketStatus.open;
  }

  @override
  dynamic toJson(TicketStatus object) => object.name;
}
