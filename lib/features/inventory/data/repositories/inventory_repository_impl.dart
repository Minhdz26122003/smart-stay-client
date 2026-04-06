// lib/features/inventory/data/repositories/inventory_repository_impl.dart
import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_datasource.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource _dataSource;
  InventoryRepositoryImpl({required InventoryRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<InventoryItem>> getInventoryByContract(String contractId) async {
    final models = await _dataSource.getInventoryByContract(contractId);
    return models.map((m) => m.toEntity()).toList();
  }
}
