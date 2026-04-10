import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/listing_repository.dart';
import 'listing_state.dart';
import '../../../../core/network/app_exception.dart';

class ListingCubit extends Cubit<ListingState> {
  final ListingRepository _repository;

  ListingCubit({required ListingRepository repository})
      : _repository = repository,
        super(const ListingState.initial());

  Future<void> loadLandlordListings(String? propertyId) async {
    emit(const ListingState.loading());
    try {
      final listings = await _repository.getLandlordListings(propertyId);
      emit(ListingState.loaded(listings));
    } on AppException catch (e) {
      emit(ListingState.error(e.message));
    } catch (e) {
      emit(ListingState.error(e.toString()));
    }
  }

  Future<void> loadTenantListings() async {
    emit(const ListingState.loading());
    try {
      final listings = await _repository.getTenantListings();
      emit(ListingState.loaded(listings));
    } on AppException catch (e) {
      emit(ListingState.error(e.message));
    } catch (e) {
      emit(ListingState.error(e.toString()));
    }
  }

  Future<void> createListing({
    required String propertyId,
    String? roomId,
    required String title,
    required String description,
    required double price,
    required double area,
    required List<String> facilities,
    List<String>? photoUrls,
  }) async {
    emit(const ListingState.loading());
    try {
      await _repository.createListing(
        propertyId: propertyId,
        roomId: roomId,
        title: title,
        description: description,
        price: price,
        area: area,
        facilities: facilities,
        photoUrls: photoUrls,
      );
      // Reload landlord listings
      await loadLandlordListings(propertyId);
    } on AppException catch (e) {
      emit(ListingState.error(e.message));
    } catch (e) {
      emit(ListingState.error(e.toString()));
    }
  }

  Future<void> toggleListing(String listingId, String? currentPropertyId) async {
    try {
      await _repository.toggleListing(listingId);
      // reload lists
      await loadLandlordListings(currentPropertyId);
    } on AppException catch (e) {
      emit(ListingState.error(e.message));
    } catch (e) {
      emit(ListingState.error(e.toString()));
    }
  }
}
