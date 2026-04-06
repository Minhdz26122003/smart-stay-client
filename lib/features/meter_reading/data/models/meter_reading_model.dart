// lib/features/meter_reading/data/models/meter_reading_model.dart
import '../../domain/entities/meter_reading.dart';

class MeterReadingModel {
  final String id;
  final String roomId;
  final String type;
  final int oldUnit;
  final int newUnit;
  final int month;
  final int year;
  final String? photoUrl;

  const MeterReadingModel({
    required this.id,
    required this.roomId,
    required this.type,
    required this.oldUnit,
    required this.newUnit,
    required this.month,
    required this.year,
    this.photoUrl,
  });

  factory MeterReadingModel.fromJson(Map<String, dynamic> json) {
    return MeterReadingModel(
      id: json['id'] as String? ?? '',
      roomId: json['roomId'] as String? ?? '',
      type: json['type'] as String? ?? 'Electricity',
      oldUnit: (json['oldUnit'] as num?)?.toInt() ?? 0,
      newUnit: (json['newUnit'] as num?)?.toInt() ?? 0,
      month: (json['month'] as num?)?.toInt() ?? 1,
      year: (json['year'] as num?)?.toInt() ?? 2025,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  MeterReading toEntity() {
    return MeterReading(
      id: id,
      roomId: roomId,
      type: MeterType.fromString(type),
      oldUnit: oldUnit,
      newUnit: newUnit,
      month: month,
      year: year,
      photoUrl: photoUrl,
    );
  }
}
