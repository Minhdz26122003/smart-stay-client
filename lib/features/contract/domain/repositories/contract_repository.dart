// lib/features/contract/domain/repositories/contract_repository.dart

import '../entities/contract.dart';

abstract class ContractRepository {
  Future<Contract> createContract({
    required String roomId,
    required String tenantPhone,
    required String tenantName,
    required String tenantIdCard,
    required String? tenantEmail,
    required DateTime startDate,
    required DateTime endDate,
    required double monthlyRent,
    required double depositAmount,
    required int maxOccupants,
  });
  Future<List<Contract>> getContractsByRoom(String roomId);
  Future<List<Contract>> getContractsByProperty(String propertyId);
}
