import '../entities/ticket.dart';

abstract class TicketRepository {
  Future<List<Ticket>> getLandlordTickets();
  Future<List<Ticket>> getTenantTickets();
  Future<void> updateTicketStatus(String id, TicketStatus newStatus);
  Future<Ticket> createTicket({
    required String propertyId,
    required String roomId,
    required String title,
    required String description,
    required TicketCategory category,
    required TicketPriority priority,
  });
}
