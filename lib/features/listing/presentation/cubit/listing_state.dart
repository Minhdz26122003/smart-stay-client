import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/listing.dart';

part 'listing_state.freezed.dart';

@freezed
class ListingState with _$ListingState {
  const factory ListingState.initial() = _Initial;
  const factory ListingState.loading() = _Loading;
  const factory ListingState.loaded(List<Listing> listings) = _Loaded;
  const factory ListingState.error(String message) = _Error;
}
