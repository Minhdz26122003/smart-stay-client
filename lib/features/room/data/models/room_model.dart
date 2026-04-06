// lib/features/room/data/models/room_model.dart

import '../../domain/entities/room.dart';

class RoomModel {
  final String id;
  final String propertyId;
  final String name;
  final String type;
  final double basePrice;
  final double areaM2;
  final int status;
  final int maxOccupants;

  const RoomModel({
    required this.id,
    required this.propertyId,
    required this.name,
    required this.type,
    required this.basePrice,
    required this.areaM2,
    required this.status,
    required this.maxOccupants,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String? ?? '',
      propertyId: json['propertyId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      areaM2: (json['areaM2'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as int? ?? 0,
      maxOccupants: json['maxOccupants'] as int? ?? 1,
    );
  }

  Room toEntity() => Room(
        id: id,
        propertyId: propertyId,
        name: name,
        type: type,
        basePrice: basePrice,
        areaM2: areaM2,
        status: RoomStatus.fromInt(status),
        maxOccupants: maxOccupants,
      );
}
