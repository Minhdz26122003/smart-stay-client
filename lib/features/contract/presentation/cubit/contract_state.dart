// lib/features/contract/presentation/cubit/contract_state.dart

import 'package:equatable/equatable.dart';

abstract class ContractState extends Equatable {
  const ContractState();
  @override
  List<Object?> get props => [];
}

class ContractInitial extends ContractState {}

class ContractSubmitting extends ContractState {}

class ContractSubmitSuccess extends ContractState {}

class ContractSubmitError extends ContractState {
  final String message;
  const ContractSubmitError(this.message);
  @override
  List<Object?> get props => [message];
}
