// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TicketModel _$TicketModelFromJson(Map<String, dynamic> json) => _TicketModel(
  id: json['id'] as String,
  propertyId: json['propertyId'] as String?,
  roomId: json['roomId'] as String,
  tenantId: json['tenantId'] as String,
  tenantName: json['tenantName'] as String?,
  roomName: json['roomName'] as String?,
  category: $enumDecodeNullable(
    _$TicketCategoryEnumMap,
    json['category'],
    unknownValue: TicketCategory.other,
  ),
  priority: $enumDecodeNullable(
    _$TicketPriorityEnumMap,
    json['priority'],
    unknownValue: TicketPriority.low,
  ),
  title: json['title'] as String,
  description: json['description'] as String,
  status: json['status'] == null
      ? TicketStatus.pending
      : const TicketStatusConverter().fromJson(json['status']),
  photoUrls: (json['photoUrls'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TicketModelToJson(_TicketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyId': instance.propertyId,
      'roomId': instance.roomId,
      'tenantId': instance.tenantId,
      'tenantName': instance.tenantName,
      'roomName': instance.roomName,
      'category': _$TicketCategoryEnumMap[instance.category],
      'priority': _$TicketPriorityEnumMap[instance.priority],
      'title': instance.title,
      'description': instance.description,
      'status': const TicketStatusConverter().toJson(instance.status),
      'photoUrls': instance.photoUrls,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$TicketCategoryEnumMap = {
  TicketCategory.electricity: 'Electricity',
  TicketCategory.water: 'Water',
  TicketCategory.furniture: 'Furniture',
  TicketCategory.other: 'Other',
};

const _$TicketPriorityEnumMap = {
  TicketPriority.low: 'Low',
  TicketPriority.medium: 'Medium',
  TicketPriority.high: 'High',
  TicketPriority.urgent: 'Urgent',
};
