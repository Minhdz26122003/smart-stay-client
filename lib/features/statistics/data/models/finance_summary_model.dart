// lib/features/statistics/data/models/finance_summary_model.dart
import '../../domain/entities/finance_summary.dart';

class MonthlyRevenueModel extends MonthlyRevenue {
  const MonthlyRevenueModel({
    required super.month,
    required super.value,
  });

  factory MonthlyRevenueModel.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenueModel(
      month: json['month'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class FinanceSummaryModel extends FinanceSummary {
  const FinanceSummaryModel({
    required super.totalRevenue,
    required super.unpaidAmount,
    required super.occupancyRate,
    required super.totalRooms,
    required super.occupiedRooms,
    required super.emptyRooms,
    required super.maintenanceRooms,
    required super.monthlyRevenue,
  });

  factory FinanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return FinanceSummaryModel(
      totalRevenue: (json['totalRevenue'] as num? ??
              json['totalRevenueCurrentMonth'] as num?)
          ?.toDouble() ??
      0.0,
      unpaidAmount:
          (json['unpaidAmount'] as num? ?? json['uncollectedAmount'] as num?)
              ?.toDouble() ??
      0.0,
      occupancyRate: (json['occupancyRate'] as num?)?.toDouble() ?? 0.0,
      totalRooms: json['totalRooms'] as int? ?? json['totalRoomsCount'] as int? ?? 0,
      occupiedRooms:
          json['occupiedRooms'] as int? ?? json['occupiedRoomsCount'] as int? ?? 0,
      emptyRooms:
          json['emptyRooms'] as int? ?? json['emptyRoomsCount'] as int? ?? 0,
      maintenanceRooms: json['maintenanceRooms'] as int? ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] as List<dynamic>?)
              ?.map((e) => MonthlyRevenueModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
