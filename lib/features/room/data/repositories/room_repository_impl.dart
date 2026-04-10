// lib/features/room/data/repositories/room_repository_impl.dart

import '../../domain/entities/room.dart';
import '../../domain/entities/room_detail.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_remote_datasource.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource _remoteDataSource;

  RoomRepositoryImpl({required RoomRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Room>> getRoomsByProperty(String propertyId) async {
    final models = await _remoteDataSource.getRoomsByProperty(propertyId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<RoomDetail> getRoomDetail(String roomId) async {
    final model = await _remoteDataSource.getRoomDetail(roomId);
    return model.toEntity();
  }

  @override
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
  }) async {
    final model = await _remoteDataSource.createRoom(
      propertyId: propertyId,
      name: name,
      floor: floor,
      area: area,
      maxOccupancy: maxOccupancy,
      basePrice: basePrice,
      description: description,
      type: type,
      facilities: facilities,
      photoUrls: photoUrls,
    );
    return model.toEntity();
  }
}
