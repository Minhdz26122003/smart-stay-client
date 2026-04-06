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
}
