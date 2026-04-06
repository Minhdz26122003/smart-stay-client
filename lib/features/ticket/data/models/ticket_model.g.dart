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
  category: (json['category'] as num?)?.toInt(),
  priority: (json['priority'] as num?)?.toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  status:
      $enumDecodeNullable(_$TicketStatusEnumMap, json['status']) ??
      TicketStatus.open,
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
      'category': instance.category,
      'priority': instance.priority,
      'title': instance.title,
      'description': instance.description,
      'status': _$TicketStatusEnumMap[instance.status]!,
      'photoUrls': instance.photoUrls,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$TicketStatusEnumMap = {
  TicketStatus.open: 0,
  TicketStatus.inProgress: 1,
  TicketStatus.resolved: 2,
  TicketStatus.closed: 3,
};
