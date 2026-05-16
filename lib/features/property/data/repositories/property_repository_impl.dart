// lib/features/property/data/repositories/property_repository_impl.dart

import '../../domain/entities/property.dart';
import '../../domain/repositories/property_repository.dart';
import '../datasources/property_remote_datasource.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyRemoteDataSource _remoteDataSource;

  PropertyRepositoryImpl({required PropertyRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Property>> getProperties() async {
    final models = await _remoteDataSource.getProperties();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> deleteProperty(String propertyId) async {
    await _remoteDataSource.deleteProperty(propertyId);
  }
}
