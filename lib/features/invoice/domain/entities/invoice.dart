// lib/features/invoice/domain/entities/invoice.dart

enum InvoiceStatus {
  unpaid(0),
  paid(1),
  partialPaid(2),
  overdue(3);

  final int value;
  const InvoiceStatus(this.value);

  factory InvoiceStatus.fromInt(int v) =>
      InvoiceStatus.values.firstWhere((e) => e.value == v,
          orElse: () => InvoiceStatus.unpaid);

  String get displayName {
    switch (this) {
      case InvoiceStatus.unpaid:
        return 'Chưa thanh toán';
      case InvoiceStatus.paid:
        return 'Đã thanh toán';
      case InvoiceStatus.partialPaid:
        return 'Thanh toán một phần';
      case InvoiceStatus.overdue:
        return 'Quá hạn';
    }
  }
}

class InvoiceBreakdown {
  final double rent;
  final double electricityAmount;
  final int electricityConsumed;
  final double waterAmount;
  final int waterConsumed;
  final double internet;
  final double garbage;

  const InvoiceBreakdown({
    required this.rent,
    required this.electricityAmount,
    required this.electricityConsumed,
    required this.waterAmount,
    required this.waterConsumed,
    required this.internet,
    required this.garbage,
  });
}

class Invoice {
  final String id;
  final String roomId;
  final String contractId;
  final int month;
  final int year;
  final double totalAmount;
  final double paidAmount;
  final InvoiceStatus status;
  final InvoiceBreakdown? breakdown;
  final DateTime createdAt;

  const Invoice({
    required this.id,
    required this.roomId,
    required this.contractId,
    required this.month,
    required this.year,
    required this.totalAmount,
    required this.paidAmount,
    required this.status,
    this.breakdown,
    required this.createdAt,
  });

  String get periodLabel => 'Tháng $month/$year';

  bool get isPaid => status == InvoiceStatus.paid;
}
