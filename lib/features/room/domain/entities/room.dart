// lib/features/room/domain/entities/room.dart

enum RoomStatus {
  available('Available'),
  occupied('Occupied'),
  underRepair('UnderRepair'),
  reserved('Reserved');

  final String value;
  const RoomStatus(this.value);

  factory RoomStatus.fromString(String value) {
    final v = value.toLowerCase();
    if (v == 'empty' || v == 'available') return RoomStatus.available;
    if (v == 'rented' || v == 'occupied') return RoomStatus.occupied;
    if (v == 'maintenance' || v == 'underrepair') return RoomStatus.underRepair;
    if (v == 'reserved') return RoomStatus.reserved;
    
    return RoomStatus.available; // Default
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
