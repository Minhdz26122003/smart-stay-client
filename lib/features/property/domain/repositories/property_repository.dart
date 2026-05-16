// lib/features/property/domain/repositories/property_repository.dart

import '../entities/property.dart';

abstract class PropertyRepository {
  Future<List<Property>> getProperties();
  Future<void> deleteProperty(String propertyId);
}
