import '../../domain/entities/ticket.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_remote_data_source.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketRemoteDataSource _remoteDataSource;

  TicketRepositoryImpl({required TicketRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Ticket>> getLandlordTickets() async {
    final models = await _remoteDataSource.getLandlordTickets();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Ticket>> getTenantTickets() async {
    final models = await _remoteDataSource.getTenantTickets();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> updateTicketStatus(String id, TicketStatus newStatus) async {
    await _remoteDataSource.updateTicketStatus(id, newStatus);
  }

  @override
  Future<Ticket> createTicket({
    required String propertyId,
    required String roomId,
    required String title,
    required String description,
    required TicketCategory category,
    required TicketPriority priority,
  }) async {
    final model = await _remoteDataSource.createTicket(
      propertyId: propertyId,
      roomId: roomId,
      title: title,
      description: description,
      category: category,
      priority: priority,
    );
    return model.toEntity();
  }
}
