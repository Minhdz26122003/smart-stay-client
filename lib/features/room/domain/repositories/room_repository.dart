// lib/features/room/domain/repositories/room_repository.dart

import '../entities/room.dart';
import '../entities/room_detail.dart';

abstract class RoomRepository {
  Future<List<Room>> getRoomsByProperty(String propertyId);
  Future<RoomDetail> getRoomDetail(String roomId);
  Future<Room> createRoom({
    required String propertyId,
    required String name,
    required int floor,
    required double area,
    required int maxOccupancy,
    required double basePrice,
    required String description,
    required String type,
    required List<String> facilities,
    List<String>? photoUrls,
  });
}
