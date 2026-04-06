// lib/features/room/presentation/cubit/room_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/room.dart';

part 'room_state.freezed.dart';

@freezed
class RoomState with _$RoomState {
  const factory RoomState.initial() = _Initial;
  const factory RoomState.loading() = _Loading;
  const factory RoomState.loaded(List<Room> rooms) = _Loaded;
  const factory RoomState.error(String message) = _Error;
}
