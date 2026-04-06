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
    int? category,
    int? priority,
    required String title,
    required String description,
    @Default(TicketStatus.open) TicketStatus status,
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
