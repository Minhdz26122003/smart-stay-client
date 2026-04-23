// lib/features/statistics/presentation/cubit/finance_summary_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/statistics_repository.dart';
import 'finance_summary_state.dart';

class FinanceSummaryCubit extends Cubit<FinanceSummaryState> {
  final StatisticsRepository _repository;

  FinanceSummaryCubit({required StatisticsRepository repository})
      : _repository = repository,
        super(FinanceSummaryInitial());

  Future<void> loadFinanceSummary({String? propertyId}) async {
    emit(FinanceSummaryLoading());
    try {
      final summary = await _repository.getFinanceSummary(propertyId: propertyId);
      emit(FinanceSummaryLoaded(summary));
    } catch (e) {
      emit(FinanceSummaryError(e.toString()));
    }
  }
}
