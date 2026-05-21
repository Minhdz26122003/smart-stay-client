// lib/features/inventory/data/models/inventory_item_model.dart
import '../../domain/entities/inventory_item.dart';

class InventoryItemModel {
  final String id;
  final String contractId;
  final String itemName;
  final int condition;
  final List<String> checkInPhotos;
  final List<String> checkOutPhotos;
  final DateTime createdAt;

  const InventoryItemModel({
    required this.id,
    required this.contractId,
    required this.itemName,
    required this.condition,
    required this.checkInPhotos,
    required this.checkOutPhotos,
    required this.createdAt,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    List<String> parsePhotos(dynamic val) {
      if (val is List) {
        return val.map((e) => e.toString()).toList();
      }
      return [];
    }

    // Helper function to safely parse integer from dynamic value
    int parseIntSafe(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return InventoryItemModel(
      id: json['id'] as String? ?? '',
      contractId: json['contractId'] as String? ?? '',
      itemName: json['itemName'] as String? ?? '',
      condition: parseIntSafe(json['condition']),  // ✅ Fixed: Safe parsing
      checkInPhotos: parsePhotos(json['checkInPhotos']),
      checkOutPhotos: parsePhotos(json['checkOutPhotos']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  InventoryItem toEntity() {
    return InventoryItem(
      id: id,
      contractId: contractId,
      itemName: itemName,
      condition: ItemCondition.fromInt(condition),
      checkInPhotos: checkInPhotos,
      checkOutPhotos: checkOutPhotos,
      createdAt: createdAt,
    );
  }
}
