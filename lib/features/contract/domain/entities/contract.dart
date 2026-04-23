// lib/features/contract/domain/entities/contract.dart

enum ContractStatus {
  draft('Draft'),
  active('Active'),
  expired('Expired'),
  terminated('Terminated');

  final String value;
  const ContractStatus(this.value);

  factory ContractStatus.fromString(String v) {
    // Legacy numeric mapping
    if (v == '0') return ContractStatus.active;
    if (v == '1') return ContractStatus.expired;

    return ContractStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == v.toLowerCase(),
      orElse: () => ContractStatus.active,
    );
  }
}

class Contract {
  final String id;
  final String roomId;
  final String tenantId;
  final DateTime startDate;
  final DateTime endDate;
  final double monthlyRent;
  final double depositAmount;
  final int maxOccupants;
  final ContractStatus status;

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
