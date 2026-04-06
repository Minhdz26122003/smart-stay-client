// lib/features/inventory/domain/entities/inventory_item.dart

enum ItemCondition {
  good(0),
  damaged(1),
  missing(2);

  final int value;
  const ItemCondition(this.value);

  factory ItemCondition.fromInt(int v) =>
      ItemCondition.values.firstWhere((e) => e.value == v,
          orElse: () => ItemCondition.good);

  String get displayName {
    switch (this) {
      case ItemCondition.good:
        return 'Tốt';
      case ItemCondition.damaged:
        return 'Hư hỏng';
      case ItemCondition.missing:
        return 'Mất';
    }
  }
}

class InventoryItem {
  final String id;
  final String contractId;
  final String itemName;
  final ItemCondition condition;
  final List<String> checkInPhotos;
  final List<String> checkOutPhotos;
  final DateTime createdAt;

  const InventoryItem({
    required this.id,
    required this.contractId,
    required this.itemName,
    required this.condition,
    required this.checkInPhotos,
    required this.checkOutPhotos,
    required this.createdAt,
  });
}
