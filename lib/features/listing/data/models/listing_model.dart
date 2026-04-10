import '../../domain/entities/listing.dart';

class ListingModel {
  final String id;
  final String landlordId;
  final String propertyId;
  final String? roomId;
  final String title;
  final String description;
  final double price;
  final double area;
  final List<String> facilities;
  final List<String> photoUrls;
  final bool isActive;
  final DateTime createdAt;

  const ListingModel({
    required this.id,
    required this.landlordId,
    required this.propertyId,
    this.roomId,
    required this.title,
    required this.description,
    required this.price,
    required this.area,
    required this.facilities,
    required this.photoUrls,
    required this.isActive,
    required this.createdAt,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as String? ?? '',
      landlordId: json['landlordId'] as String? ?? '',
      propertyId: json['propertyId'] as String? ?? '',
      roomId: json['roomId'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      facilities: (json['facilities'] as List?)?.map((e) => e.toString()).toList() ?? [],
      photoUrls: (json['photoUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Listing toEntity() => Listing(
        id: id,
        landlordId: landlordId,
        propertyId: propertyId,
        roomId: roomId,
        title: title,
        description: description,
        price: price,
        area: area,
        facilities: facilities,
        photoUrls: photoUrls,
        isActive: isActive,
        createdAt: createdAt,
      );
}
