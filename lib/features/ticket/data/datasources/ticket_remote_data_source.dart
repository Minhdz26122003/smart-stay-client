import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/app_exception.dart';
import '../models/ticket_model.dart';
import '../../domain/entities/ticket.dart';

abstract class TicketRemoteDataSource {
  Future<List<TicketModel>> getLandlordTickets();
  Future<List<TicketModel>> getTenantTickets();
  Future<void> updateTicketStatus(String id, TicketStatus newStatus);
  Future<TicketModel> createTicket({
    required String propertyId,
    required String roomId,
    required String title,
    required String description,
    required TicketCategory category,
    required TicketPriority priority,
  });
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<TicketModel>> getLandlordTickets() async {
    try {
      final response = await _dio.get('/api/v1/tickets/landlord');
      final data = response.data['data'] as List? ?? [];
      return data.map((e) => TicketModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<List<TicketModel>> getTenantTickets() async {
    try {
      final response = await _dio.get('/api/v1/tickets/tenant');
      final data = response.data['data'] as List? ?? [];
      return data.map((e) => TicketModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<void> updateTicketStatus(String id, TicketStatus newStatus) async {
    // Enum values are 0: pending, 1: inProgress, 2: resolved, 3: cancelled
    int apiStatus = newStatus == TicketStatus.pending
        ? 0
        : newStatus == TicketStatus.inProgress
            ? 1
            : newStatus == TicketStatus.resolved
                ? 2
                : 3;
    try {
      await _dio.put(
        '/api/v1/tickets/$id/status',
        data: {'status': apiStatus},
      );
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<TicketModel> createTicket({
    required String propertyId,
    required String roomId,
    required String title,
    required String description,
    required TicketCategory category,
    required TicketPriority priority,
  }) async {
    try {
      final response = await _dio.post('/api/v1/tickets', data: {
        'propertyId': propertyId,
        'roomId': roomId,
        'title': title,
        'description': description,
        'category': _categoryToApiValue(category),
        'priority': _priorityToApiValue(priority),
      });
      return TicketModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  String _categoryToApiValue(TicketCategory category) {
    switch (category) {
      case TicketCategory.electricity:
        return 'Electricity';
      case TicketCategory.water:
        return 'Water';
      case TicketCategory.furniture:
        return 'Furniture';
      case TicketCategory.other:
        return 'Other';
    }
  }

  String _priorityToApiValue(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return 'Low';
      case TicketPriority.medium:
        return 'Medium';
      case TicketPriority.high:
        return 'High';
      case TicketPriority.urgent:
        return 'Urgent';
    }
  }
}
