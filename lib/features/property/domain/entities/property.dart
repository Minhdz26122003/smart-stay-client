// lib/features/property/domain/entities/property.dart

class Property {
  final String id;
  final String landlordId;
  final String name;
  final String? rules;
  final List<String> sharedAmenities;
  final String addressStreet;
  final String addressWard;
  final String addressDistrict;
  final String addressCity;

  const Property({
    required this.id,
    required this.landlordId,
    required this.name,
    this.rules,
    required this.sharedAmenities,
    required this.addressStreet,
    required this.addressWard,
    required this.addressDistrict,
    required this.addressCity,
  });

  String get fullAddress =>
      '$addressStreet, $addressWard, $addressDistrict, $addressCity';
}
