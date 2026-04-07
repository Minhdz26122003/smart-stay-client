// lib/features/statistics/domain/entities/finance_summary.dart
import 'package:equatable/equatable.dart';

class MonthlyRevenue extends Equatable {
  final String month;
  final double value;

  const MonthlyRevenue({
    required this.month,
    required this.value,
  });

  @override
  List<Object?> get props => [month, value];
}

class FinanceSummary extends Equatable {
  final double totalRevenue;
  final double unpaidAmount;
  final double occupancyRate;
  final int totalRooms;
  final int occupiedRooms;
  final int emptyRooms;
  final int maintenanceRooms;
  final List<MonthlyRevenue> monthlyRevenue;

  const FinanceSummary({
    required this.totalRevenue,
    required this.unpaidAmount,
    required this.occupancyRate,
    required this.totalRooms,
    required this.occupiedRooms,
    required this.emptyRooms,
    required this.maintenanceRooms,
    required this.monthlyRevenue,
  });

  @override
  List<Object?> get props => [
        totalRevenue,
        unpaidAmount,
        occupancyRate,
        totalRooms,
        occupiedRooms,
        emptyRooms,
        maintenanceRooms,
        monthlyRevenue,
      ];
}
