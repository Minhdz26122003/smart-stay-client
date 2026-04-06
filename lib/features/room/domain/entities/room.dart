// lib/features/room/domain/entities/room.dart

enum RoomStatus {
  empty(0),
  occupied(1),
  maintenance(2);

  final int value;
  const RoomStatus(this.value);

  factory RoomStatus.fromInt(int value) {
    return RoomStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RoomStatus.empty,
    );
  }
}

class Room {
  final String id;
  final String propertyId;
  final String name;
  final String type;
  final double basePrice;
  final double areaM2;
  final RoomStatus status;
  final int maxOccupants;

  const Room({
    required this.id,
    required this.propertyId,
    required this.name,
    required this.type,
    required this.basePrice,
    required this.areaM2,
    required this.status,
    required this.maxOccupants,
  });
}
