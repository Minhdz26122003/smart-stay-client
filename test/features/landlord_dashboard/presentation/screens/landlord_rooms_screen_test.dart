import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_stay_client/features/landlord_dashboard/presentation/screens/landlord_rooms_screen.dart';
import 'package:smart_stay_client/features/room/domain/entities/room.dart';
import 'package:smart_stay_client/features/room/presentation/cubit/room_cubit.dart';
import 'package:smart_stay_client/features/room/presentation/cubit/room_state.dart';

class _MockRoomCubit extends MockCubit<RoomState> implements RoomCubit {}

void main() {
  late _MockRoomCubit roomCubit;

  const room = Room(
    id: 'room-1',
    propertyId: 'property-1',
    name: 'P101',
    type: 'Studio',
    basePrice: 2500000,
    areaM2: 24,
    status: RoomStatus.available,
    maxOccupants: 2,
  );

  setUp(() {
    roomCubit = _MockRoomCubit();
    when(() => roomCubit.state).thenReturn(const RoomState.loaded([room]));
    whenListen(
      roomCubit,
      Stream<RoomState>.fromIterable(const [RoomState.loaded([room])]),
      initialState: const RoomState.loaded([room]),
    );
    when(() => roomCubit.loadRooms(any())).thenAnswer((_) async {});
  });

  testWidgets(
    'reloads rooms when room detail returns delete success',
    (tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => BlocProvider<RoomCubit>.value(
              value: roomCubit,
              child: const LandlordRoomsScreen(),
            ),
          ),
          GoRoute(
            path: '/landlord/operations/room-detail',
            builder: (context, state) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => context.pop(true),
                  child: const Text('Delete success'),
                ),
              ),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('P101'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete success'));
      await tester.pumpAndSettle();

      verify(() => roomCubit.loadRooms(room.propertyId)).called(1);
    },
  );
}
