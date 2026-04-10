import '../../domain/entities/listing.dart';
import '../../domain/repositories/listing_repository.dart';
import '../datasources/listing_remote_datasource.dart';

class ListingRepositoryImpl implements ListingRepository {
  final ListingRemoteDataSource _remoteDataSource;

  ListingRepositoryImpl({required ListingRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Listing>> getLandlordListings(String? propertyId) async {
    final models = await _remoteDataSource.getLandlordListings(propertyId);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Listing>> getTenantListings() async {
    final models = await _remoteDataSource.getTenantListings();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> toggleListing(String listingId) async {
    await _remoteDataSource.toggleListing(listingId);
  }

  @override
  Future<Listing> createListing({
    required String propertyId,
    String? roomId,
    required String title,
    required String description,
    required double price,
    required double area,
    required List<String> facilities,
    List<String>? photoUrls,
  }) async {
    final model = await _remoteDataSource.createListing(
      propertyId: propertyId,
      roomId: roomId,
      title: title,
      description: description,
      price: price,
      area: area,
      facilities: facilities,
      photoUrls: photoUrls,
    );
    return model.toEntity();
  }
}
