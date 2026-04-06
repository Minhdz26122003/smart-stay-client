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
    // Enum sang chữ hoa ví dụ như Resolved -> Resolved (đã config JsonValue)
    final apiStatus = newStatus == TicketStatus.open ? "Open" 
        : newStatus == TicketStatus.inProgress ? "InProgress" 
      : "Resolved";
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
  }) async {
    try {
      final response = await _dio.post('/api/v1/tickets', data: {
        'propertyId': propertyId,
        'roomId': roomId,
        'title': title,
        'description': description,
      });
      return TicketModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}

