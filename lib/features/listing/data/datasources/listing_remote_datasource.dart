import 'package:dio/dio.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/listing_model.dart';

abstract class ListingRemoteDataSource {
  Future<List<ListingModel>> getLandlordListings(String? propertyId);
  Future<List<ListingModel>> getTenantListings();
  Future<void> toggleListing(String listingId);
  Future<ListingModel> createListing({
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

class ListingRemoteDataSourceImpl implements ListingRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<ListingModel>> getLandlordListings(String? propertyId) async {
    try {
      final query = propertyId != null ? '?propertyId=$propertyId' : '';
      final response = await _dio.get('/api/v1/listings/landlord$query');
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data.map((e) => ListingModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<List<ListingModel>> getTenantListings() async {
    try {
      final response = await _dio.get('/api/v1/listings');
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data.map((e) => ListingModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<void> toggleListing(String listingId) async {
    try {
      await _dio.put('/api/v1/listings/$listingId/toggle');
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<ListingModel> createListing({
    required String propertyId,
    String? roomId,
    required String title,
    required String description,
    required double price,
    required double area,
    required List<String> facilities,
    List<String>? photoUrls,
  }) async {
    try {
      final response = await _dio.post('/api/v1/listings', data: {
        'propertyId': propertyId,
        if (roomId != null) 'roomId': roomId,
        'title': title,
        'description': description,
        'price': price,
        'area': area,
        'facilities': facilities,
        if (photoUrls != null) 'photoUrls': photoUrls,
      });
      return ListingModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
