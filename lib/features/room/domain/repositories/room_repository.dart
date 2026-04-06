// lib/features/room/domain/repositories/room_repository.dart

import '../entities/room.dart';
import '../entities/room_detail.dart';

abstract class RoomRepository {
  Future<List<Room>> getRoomsByProperty(String propertyId);
  Future<RoomDetail> getRoomDetail(String roomId);
}
