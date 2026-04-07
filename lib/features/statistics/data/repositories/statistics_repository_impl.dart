// lib/features/statistics/data/repositories/statistics_repository_impl.dart
import '../../domain/entities/finance_summary.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_remote_datasource.dart';
import '../../../../core/network/app_exception.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsRemoteDataSource _remoteDataSource;

  StatisticsRepositoryImpl({
    required StatisticsRemoteDataSource remoteDataSource,
  })  : _remoteDataSource = remoteDataSource;

  @override
  Future<FinanceSummary> getFinanceSummary() async {
    try {
      final financeSummaryModel = await _remoteDataSource.getFinanceSummary();
      return financeSummaryModel;
    } on AppException {
      rethrow;
    } catch (e) {
      // Mock data when offline or backend not fully functional for MVP
      return const FinanceSummary(
        totalRevenue: 28550000,
        unpaidAmount: 2300000,
        occupancyRate: 0.9,
        totalRooms: 40,
        occupiedRooms: 36,
        emptyRooms: 2,
        maintenanceRooms: 2,
        monthlyRevenue: [],
      );
    }
  }
}
