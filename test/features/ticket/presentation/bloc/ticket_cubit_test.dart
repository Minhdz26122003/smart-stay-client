import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_stay_client/core/network/app_exception.dart';
import 'package:smart_stay_client/features/ticket/domain/entities/ticket.dart';
import 'package:smart_stay_client/features/ticket/domain/repositories/ticket_repository.dart';
import 'package:smart_stay_client/features/ticket/presentation/bloc/ticket_cubit.dart';
import 'package:smart_stay_client/features/ticket/presentation/bloc/ticket_state.dart';

class _MockTicketRepository extends Mock implements TicketRepository {}

void main() {
  late TicketRepository repository;
  late TicketCubit cubit;

  final createdTicket = Ticket(
    id: 'ticket-1',
    propertyId: 'property-1',
    roomId: 'room-1',
    tenantId: 'tenant-1',
    tenantName: 'Nguyen Van A',
    roomName: 'P101',
    category: TicketCategory.water,
    priority: TicketPriority.urgent,
    title: 'Nuoc - Phong tam',
    description: 'Voi nuoc bi ro ri.',
    status: TicketStatus.pending,
    createdAt: DateTime(2026, 5, 16),
  );

  final refreshedTenantTickets = [
    createdTicket,
  ];

  final refreshedLandlordTickets = [
    createdTicket.copyWith(status: TicketStatus.resolved),
  ];

  setUp(() {
    repository = _MockTicketRepository();
    cubit = TicketCubit(repository: repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  blocTest<TicketCubit, TicketState>(
    'emits submitting, submit success, and refreshed tenant tickets when create succeeds',
    build: () {
      when(
        () => repository.createTicket(
          propertyId: 'property-1',
          roomId: 'room-1',
          title: 'Nuoc - Phong tam',
          description: 'Voi nuoc bi ro ri.',
          category: TicketCategory.water,
          priority: TicketPriority.urgent,
        ),
      ).thenAnswer((_) async => createdTicket);
      when(() => repository.getTenantTickets())
          .thenAnswer((_) async => refreshedTenantTickets);
      return cubit;
    },
    act: (cubit) => cubit.createTicket(
      propertyId: 'property-1',
      roomId: 'room-1',
      title: 'Nuoc - Phong tam',
      description: 'Voi nuoc bi ro ri.',
      category: TicketCategory.water,
      priority: TicketPriority.urgent,
    ),
    expect: () => [
      const TicketSubmitting(),
      TicketSubmitSuccess(ticket: createdTicket),
      const TicketLoading(),
      TicketLoaded(tickets: refreshedTenantTickets),
    ],
  );

  blocTest<TicketCubit, TicketState>(
    'emits status update progress, success, and refreshed landlord tickets when resolving succeeds',
    build: () {
      when(() => repository.updateTicketStatus('ticket-1', TicketStatus.resolved))
          .thenAnswer((_) async {});
      when(() => repository.getLandlordTickets())
          .thenAnswer((_) async => refreshedLandlordTickets);
      return cubit;
    },
    seed: () => TicketLoaded(tickets: [createdTicket]),
    act: (cubit) => cubit.updateTicketStatus(
      'ticket-1',
      TicketStatus.resolved,
    ),
    expect: () => [
      TicketStatusUpdating(
        tickets: [createdTicket],
        ticketId: 'ticket-1',
        newStatus: TicketStatus.resolved,
        isLandlord: true,
      ),
      const TicketStatusUpdateSuccess(
        ticketId: 'ticket-1',
        newStatus: TicketStatus.resolved,
        isLandlord: true,
      ),
      const TicketLoading(),
      TicketLoaded(tickets: refreshedLandlordTickets),
    ],
  );

  blocTest<TicketCubit, TicketState>(
    'emits submit error when create fails',
    build: () {
      when(
        () => repository.createTicket(
          propertyId: 'property-1',
          roomId: 'room-1',
          title: 'Nuoc - Phong tam',
          description: 'Voi nuoc bi ro ri.',
          category: TicketCategory.water,
          priority: TicketPriority.urgent,
        ),
      ).thenThrow(const AppException('Create failed'));
      return cubit;
    },
    act: (cubit) => cubit.createTicket(
      propertyId: 'property-1',
      roomId: 'room-1',
      title: 'Nuoc - Phong tam',
      description: 'Voi nuoc bi ro ri.',
      category: TicketCategory.water,
      priority: TicketPriority.urgent,
    ),
    expect: () => [
      const TicketSubmitting(),
      const TicketSubmitError(message: 'Create failed'),
    ],
  );
}
