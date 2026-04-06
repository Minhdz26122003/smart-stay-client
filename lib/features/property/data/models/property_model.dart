// lib/features/property/data/models/property_model.dart

import '../../domain/entities/property.dart';

class PropertyModel {
  final String id;
  final String landlordId;
  final String name;
  final String? rules;
  final List<String> sharedAmenities;
  final String addressStreet;
  final String addressWard;
  final String addressDistrict;
  final String addressCity;

  const PropertyModel({
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

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String? ?? '',
      landlordId: json['landlordId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      rules: json['rules'] as String?,
      sharedAmenities: (json['sharedAmenities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      addressStreet: json['addressStreet'] as String? ?? '',
      addressWard: json['addressWard'] as String? ?? '',
      addressDistrict: json['addressDistrict'] as String? ?? '',
      addressCity: json['addressCity'] as String? ?? '',
    );
  }

  Property toEntity() => Property(
        id: id,
        landlordId: landlordId,
        name: name,
        rules: rules,
        sharedAmenities: sharedAmenities,
        addressStreet: addressStreet,
        addressWard: addressWard,
        addressDistrict: addressDistrict,
        addressCity: addressCity,
      );
}
