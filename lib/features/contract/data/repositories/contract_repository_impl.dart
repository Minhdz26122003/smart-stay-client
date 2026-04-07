// lib/features/contract/data/repositories/contract_repository_impl.dart

import '../../domain/entities/contract.dart';
import '../../domain/repositories/contract_repository.dart';
import '../datasources/contract_remote_datasource.dart';

class ContractRepositoryImpl implements ContractRepository {
  final ContractRemoteDataSource _dataSource;

  ContractRepositoryImpl({required ContractRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
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
  }) async {
    return _dataSource.createContract({
      'roomId': roomId,
      'tenantPhone': tenantPhone,
      'tenantName': tenantName,
      'tenantIdCard': tenantIdCard,
      if (tenantEmail != null && tenantEmail.isNotEmpty) 'tenantEmail': tenantEmail,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'monthlyRent': monthlyRent,
      'depositAmount': depositAmount,
      'maxOccupants': maxOccupants,
    });
  }

  @override
  Future<List<Contract>> getContractsByRoom(String roomId) async {
    return _dataSource.getContractsByRoom(roomId);
  }
}
