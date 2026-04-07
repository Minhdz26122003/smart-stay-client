// lib/features/statistics/domain/repositories/statistics_repository.dart
import '../entities/finance_summary.dart';

abstract class StatisticsRepository {
  Future<FinanceSummary> getFinanceSummary();
}
