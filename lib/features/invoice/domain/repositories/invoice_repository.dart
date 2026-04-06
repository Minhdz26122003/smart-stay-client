// lib/features/invoice/domain/repositories/invoice_repository.dart
import '../entities/invoice.dart';

abstract class InvoiceRepository {
  Future<List<Invoice>> getInvoicesByContract(String contractId);
}
