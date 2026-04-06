// lib/features/invoice/data/repositories/invoice_repository_impl.dart
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_remote_datasource.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource _dataSource;
  InvoiceRepositoryImpl({required InvoiceRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<Invoice>> getInvoicesByContract(String contractId) async {
    final models = await _dataSource.getInvoicesByContract(contractId);
    return models.map((m) => m.toEntity()).toList();
  }
}
