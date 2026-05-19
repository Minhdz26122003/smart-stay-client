// lib/features/contract/presentation/cubit/contract_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/contract.dart';

abstract class ContractState extends Equatable {
  const ContractState();
  @override
  List<Object?> get props => [];
}

class ContractInitial extends ContractState {}

class ContractLoading extends ContractState {
  const ContractLoading();
}

class ContractLoaded extends ContractState {
  final List<Contract> contracts;
  final String propertyId;

  const ContractLoaded({
    required this.contracts,
    required this.propertyId,
  });

  @override
  List<Object?> get props => [contracts, propertyId];
}

class ContractError extends ContractState {
  final String message;

  const ContractError(this.message);

  @override
  List<Object?> get props => [message];
}

class ContractSubmitting extends ContractState {}

class ContractSubmitSuccess extends ContractState {}

class ContractSubmitError extends ContractState {
  final String message;
  const ContractSubmitError(this.message);
  @override
  List<Object?> get props => [message];
}
