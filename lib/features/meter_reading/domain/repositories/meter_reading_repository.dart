// lib/features/meter_reading/domain/repositories/meter_reading_repository.dart
import '../entities/meter_reading.dart';

abstract class MeterReadingRepository {
  Future<List<MeterReading>> getMeterReadingsByRoom(String roomId);
}
