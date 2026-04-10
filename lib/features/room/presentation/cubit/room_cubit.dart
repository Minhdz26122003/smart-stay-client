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

  Future<void> createRoom({
    required String propertyId,
    required String name,
    required int floor,
    required double area,
    required int maxOccupancy,
    required double basePrice,
    required String description,
    required String type,
    required List<String> facilities,
    List<String>? photoUrls,
  }) async {
    emit(const RoomState.loading());
    try {
      await _repository.createRoom(
        propertyId: propertyId,
        name: name,
        floor: floor,
        area: area,
        maxOccupancy: maxOccupancy,
        basePrice: basePrice,
        description: description,
        type: type,
        facilities: facilities,
        photoUrls: photoUrls,
      );
      // Reload room list after success
      await loadRooms(propertyId);
    } on AppException catch (e) {
      emit(RoomState.error(e.message));
    } catch (e) {
      emit(RoomState.error(e.toString()));
    }
  }
}
