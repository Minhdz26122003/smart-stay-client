// lib/features/contract/data/models/contract_model.dart

import '../../domain/entities/contract.dart';

class ContractModel extends Contract {
  const ContractModel({
    required super.id,
    required super.roomId,
    required super.tenantId,
    required super.startDate,
    required super.endDate,
    required super.monthlyRent,
    required super.depositAmount,
    required super.maxOccupants,
    required super.status,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] as String,
      roomId: json['roomId'] as String? ?? '',
      tenantId: json['tenantId'] as String? ?? '',
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble() ?? 0,
      depositAmount: (json['depositAmount'] as num?)?.toDouble() ?? 0,
      maxOccupants: (json['maxOccupants'] as int?) ?? 1,
      status: json['status'] as String? ?? 'active',
    );
  }
}
