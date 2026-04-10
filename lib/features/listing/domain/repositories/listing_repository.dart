import '../entities/listing.dart';

abstract class ListingRepository {
  Future<List<Listing>> getLandlordListings(String? propertyId);
  Future<List<Listing>> getTenantListings();
  Future<void> toggleListing(String listingId);
  Future<Listing> createListing({
    required String propertyId,
    String? roomId,
    required String title,
    required String description,
    required double price,
    required double area,
    required List<String> facilities,
    List<String>? photoUrls,
  });
}
