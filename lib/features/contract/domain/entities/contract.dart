// lib/features/contract/domain/entities/contract.dart

class Contract {
  final String id;
  final String roomId;
  final String tenantId;
  final DateTime startDate;
  final DateTime endDate;
  final double monthlyRent;
  final double depositAmount;
  final int maxOccupants;
  final String status;

  const Contract({
    required this.id,
    required this.roomId,
    required this.tenantId,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    required this.depositAmount,
    required this.maxOccupants,
    required this.status,
  });
}
