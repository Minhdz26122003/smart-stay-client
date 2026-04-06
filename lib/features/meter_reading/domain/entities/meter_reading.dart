// lib/features/meter_reading/domain/entities/meter_reading.dart

enum MeterType {
  electricity,
  water;

  String get displayName =>
      this == MeterType.electricity ? 'Điện' : 'Nước';

  String get unit =>
      this == MeterType.electricity ? 'kWh' : 'm³';

  factory MeterType.fromString(String s) =>
      s.toLowerCase() == 'electricity' ? MeterType.electricity : MeterType.water;
}

class MeterReading {
  final String id;
  final String roomId;
  final MeterType type;
  final int oldUnit;
  final int newUnit;
  final int month;
  final int year;
  final String? photoUrl;

  const MeterReading({
    required this.id,
    required this.roomId,
    required this.type,
    required this.oldUnit,
    required this.newUnit,
    required this.month,
    required this.year,
    this.photoUrl,
  });

  int get consumed => newUnit - oldUnit;

  String get periodLabel => 'T$month/$year';
}
