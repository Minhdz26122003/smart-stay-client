// lib/features/contract/presentation/cubit/contract_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/app_exception.dart';
import '../../domain/repositories/contract_repository.dart';
import 'contract_state.dart';

class ContractCubit extends Cubit<ContractState> {
  final ContractRepository _repository;

  ContractCubit({required ContractRepository repository})
      : _repository = repository,
        super(ContractInitial());

  Future<void> loadContractsByProperty(String propertyId) async {
    try {
      emit(const ContractLoading());
      final contracts = await _repository.getContractsByProperty(propertyId);
      emit(ContractLoaded(contracts: contracts, propertyId: propertyId));
    } catch (e) {
      final msg = e is AppException ? e.message : e.toString();
      emit(ContractError(msg));
    }
  }

  Future<void> createContract({
    required String roomId,
    required String tenantPhone,
    required String tenantName,
    required String tenantIdCard,
    String? tenantEmail,
    required DateTime startDate,
    required DateTime endDate,
    required double monthlyRent,
    required double depositAmount,
    required int maxOccupants,
  }) async {
    try {
      emit(ContractSubmitting());
      await _repository.createContract(
        roomId: roomId,
        tenantPhone: tenantPhone,
        tenantName: tenantName,
        tenantIdCard: tenantIdCard,
        tenantEmail: tenantEmail,
        startDate: startDate,
        endDate: endDate,
        monthlyRent: monthlyRent,
        depositAmount: depositAmount,
        maxOccupants: maxOccupants,
      );
      emit(ContractSubmitSuccess());
    } catch (e) {
      final msg = e is AppException ? e.message : e.toString();
      emit(ContractSubmitError(msg));
    }
  }

  void reset() => emit(ContractInitial());
}
