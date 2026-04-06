// lib/features/invoice/data/models/invoice_model.dart
import 'dart:convert';
import '../../domain/entities/invoice.dart';

class InvoiceModel {
  final String id;
  final String roomId;
  final String contractId;
  final int month;
  final int year;
  final double totalAmount;
  final double paidAmount;
  final int status;
  final Map<String, dynamic>? breakdownJson;
  final DateTime createdAt;

  const InvoiceModel({
    required this.id,
    required this.roomId,
    required this.contractId,
    required this.month,
    required this.year,
    required this.totalAmount,
    required this.paidAmount,
    required this.status,
    this.breakdownJson,
    required this.createdAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    final breakdown = json['breakdownJson'];
    Map<String, dynamic>? bd;
    if (breakdown is Map<String, dynamic>) {
      bd = breakdown;
    } else if (breakdown is String && breakdown.isNotEmpty) {
      try {
        bd = jsonDecode(breakdown) as Map<String, dynamic>;
      } catch (_) {}
    }

    return InvoiceModel(
      id: json['id'] as String? ?? '',
      roomId: json['roomId'] as String? ?? '',
      contractId: json['contractId'] as String? ?? '',
      month: (json['month'] as num?)?.toInt() ?? 1,
      year: (json['year'] as num?)?.toInt() ?? 2025,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0,
      status: (json['status'] as num?)?.toInt() ?? 0,
      breakdownJson: bd,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Invoice toEntity() {
    return Invoice(
      id: id,
      roomId: roomId,
      contractId: contractId,
      month: month,
      year: year,
      totalAmount: totalAmount,
      paidAmount: paidAmount,
      status: InvoiceStatus.fromInt(status),
      breakdown: _parseBreakdown(),
      createdAt: createdAt,
    );
  }

  InvoiceBreakdown? _parseBreakdown() {
    final bd = breakdownJson;
    if (bd == null) return null;
    try {
      final elec = bd['electricity'] as Map<String, dynamic>?;
      final water = bd['water'] as Map<String, dynamic>?;
      return InvoiceBreakdown(
        rent: (bd['rent'] as num?)?.toDouble() ?? 0,
        electricityAmount: (elec?['amount'] as num?)?.toDouble() ?? 0,
        electricityConsumed: (elec?['consumed'] as num?)?.toInt() ?? 0,
        waterAmount: (water?['amount'] as num?)?.toDouble() ?? 0,
        waterConsumed: (water?['consumed'] as num?)?.toInt() ?? 0,
        internet: (bd['internet'] as num?)?.toDouble() ?? 0,
        garbage: (bd['garbage'] as num?)?.toDouble() ?? 0,
      );
    } catch (_) {
      return null;
    }
  }
}
