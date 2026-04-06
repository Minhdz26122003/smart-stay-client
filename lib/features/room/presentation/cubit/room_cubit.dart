// lib/features/room/presentation/cubit/room_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/room_repository.dart';
import 'room_state.dart';
import '../../../../core/network/app_exception.dart';

class RoomCubit extends Cubit<RoomState> {
  final RoomRepository _repository;

  RoomCubit({required RoomRepository repository})
      : _repository = repository,
        super(const RoomState.initial());

  Future<void> loadRooms(String propertyId) async {
    emit(const RoomState.loading());
    try {
      final rooms = await _repository.getRoomsByProperty(propertyId);
      emit(RoomState.loaded(rooms));
    } on AppException catch (e) {
      emit(RoomState.error(e.message));
    } catch (e) {
      emit(RoomState.error(e.toString()));
    }
  }
}
