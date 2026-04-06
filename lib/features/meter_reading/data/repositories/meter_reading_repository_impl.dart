// lib/features/meter_reading/data/repositories/meter_reading_repository_impl.dart
import '../../domain/entities/meter_reading.dart';
import '../../domain/repositories/meter_reading_repository.dart';
import '../datasources/meter_reading_remote_datasource.dart';

class MeterReadingRepositoryImpl implements MeterReadingRepository {
  final MeterReadingRemoteDataSource _dataSource;
  MeterReadingRepositoryImpl({required MeterReadingRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<MeterReading>> getMeterReadingsByRoom(String roomId) async {
    final models = await _dataSource.getMeterReadingsByRoom(roomId);
    return models.map((m) => m.toEntity()).toList();
  }
}
