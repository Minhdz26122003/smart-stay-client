// lib/features/inventory/domain/repositories/inventory_repository.dart
import '../entities/inventory_item.dart';

abstract class InventoryRepository {
  Future<List<InventoryItem>> getInventoryByContract(String contractId);
}
