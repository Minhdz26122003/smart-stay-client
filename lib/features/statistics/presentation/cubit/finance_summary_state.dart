// lib/features/statistics/presentation/cubit/finance_summary_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/finance_summary.dart';

abstract class FinanceSummaryState extends Equatable {
  const FinanceSummaryState();

  @override
  List<Object?> get props => [];
}

class FinanceSummaryInitial extends FinanceSummaryState {}

class FinanceSummaryLoading extends FinanceSummaryState {}

class FinanceSummaryLoaded extends FinanceSummaryState {
  final FinanceSummary summary;

  const FinanceSummaryLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class FinanceSummaryError extends FinanceSummaryState {
  final String message;

  const FinanceSummaryError(this.message);

  @override
  List<Object?> get props => [message];
}
