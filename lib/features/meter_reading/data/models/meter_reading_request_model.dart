// lib/features/meter_reading/data/models/meter_reading_request_model.dart

class MeterReadingRequestModel {
  final String roomId;
  final String type; // Data from enums: 'Electricity' or 'Water'
  final double oldUnit;
  final double newUnit;
  final String? photoUrl;
  final int month;
  final int year;

  const MeterReadingRequestModel({
    required this.roomId,
    required this.type,
    required this.oldUnit,
    required this.newUnit,
    this.photoUrl,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toJson() {
    return {
      "roomId": roomId,
      "type": type,
      "oldUnit": oldUnit,
      "newUnit": newUnit,
      if (photoUrl != null) "photoUrl": photoUrl,
      "month": month,
      "year": year,
    };
  }
}
