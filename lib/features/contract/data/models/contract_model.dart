// lib/features/contract/data/models/contract_model.dart

import '../../domain/entities/contract.dart';

class ContractModel extends Contract {
  const ContractModel({
    required super.id,
    required super.roomId,
    required super.tenantId,
    super.roomName,
    super.tenantName,
    super.tenantPhone,
    required super.startDate,
    required super.endDate,
    required super.monthlyRent,
    required super.depositAmount,
    required super.maxOccupants,
    required super.status,
    super.scannedContractUrl,
    super.createdAt,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id']?.toString() ?? '',
      roomId: json['roomId']?.toString() ?? '',
      tenantId: json['tenantId']?.toString() ?? '',
      roomName: json['roomName']?.toString(),
      tenantName: json['tenantName']?.toString(),
      tenantPhone: json['tenantPhone']?.toString(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble() ?? 0,
      depositAmount: (json['depositAmount'] as num?)?.toDouble() ?? 0,
      maxOccupants: (json['maxOccupants'] as int?) ?? 1,
      status: ContractStatus.fromString(json['status']?.toString() ?? 'Active'),
      scannedContractUrl: json['scannedContractUrl']?.toString(),
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }
}
