import 'package:freezed_annotation/freezed_annotation.dart';

part 'listing.freezed.dart';

@freezed
abstract class Listing with _$Listing {
  const factory Listing({
    required String id,
    required String landlordId,
    required String propertyId,
    String? roomId,
    required String title,
    required String description,
    required double price,
    required double area,
    required List<String> facilities,
    required List<String> photoUrls,
    required bool isActive,
    required DateTime createdAt,
  }) = _Listing;
}
