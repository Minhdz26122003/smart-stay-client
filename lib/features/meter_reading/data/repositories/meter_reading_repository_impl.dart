// lib/features/meter_reading/data/repositories/meter_reading_repository_impl.dart
import '../../domain/entities/meter_reading.dart';
import '../../domain/repositories/meter_reading_repository.dart';
import '../datasources/meter_reading_remote_datasource.dart';
import '../models/meter_reading_request_model.dart';

class MeterReadingRepositoryImpl implements MeterReadingRepository {
  final MeterReadingRemoteDataSource _dataSource;
  MeterReadingRepositoryImpl({required MeterReadingRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<MeterReading>> getMeterReadingsByRoom(String roomId) async {
    final models = await _dataSource.getMeterReadingsByRoom(roomId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<MeterReading>> getMeterReadingsByProperty(String propertyId) async {
    final models = await _dataSource.getMeterReadingsByProperty(propertyId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<MeterReading> createMeterReading(String roomId, String type, double oldUnit, double newUnit, int month, int year, [String? photoUrl]) async {
    final request = MeterReadingRequestModel(
      roomId: roomId,
      type: type,
      oldUnit: oldUnit,
      newUnit: newUnit,
      month: month,
      year: year,
      photoUrl: photoUrl,
    );
    final model = await _dataSource.createMeterReading(request.toJson());
    return model.toEntity();
  }
}
