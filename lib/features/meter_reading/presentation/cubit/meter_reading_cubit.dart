// lib/features/meter_reading/presentation/cubit/meter_reading_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/app_exception.dart';
import '../../../property/domain/repositories/property_repository.dart';
import '../../../room/domain/repositories/room_repository.dart';
import '../../../room/domain/entities/room.dart';
import '../../domain/repositories/meter_reading_repository.dart';
import '../../domain/entities/meter_reading.dart';
import 'meter_reading_state.dart';

class MeterReadingCubit extends Cubit<MeterReadingState> {
  final PropertyRepository _propertyRepository;
  final RoomRepository _roomRepository;
  final MeterReadingRepository _meterReadingRepository;

  MeterReadingCubit({
    required PropertyRepository propertyRepository,
    required RoomRepository roomRepository,
    required MeterReadingRepository meterReadingRepository,
  })  : _propertyRepository = propertyRepository,
        _roomRepository = roomRepository,
        _meterReadingRepository = meterReadingRepository,
        super(MeterReadingInitial());

  Future<void> loadProperties() async {
    try {
      emit(MeterReadingLoading());
      final properties = await _propertyRepository.getProperties();
      
      if (properties.isEmpty) {
        emit(const MeterReadingLoaded(properties: [], entries: []));
        return;
      }
      
      emit(MeterReadingLoaded(properties: properties, entries: []));
      await selectProperty(properties.first.id);
    } catch (e) {
      if (e is AppException) {
        emit(MeterReadingError(e.message));
      } else {
        emit(MeterReadingError(e.toString()));
      }
    }
  }

  Future<void> selectProperty(String propertyId) async {
    if (state is! MeterReadingLoaded) return;
    final currentState = state as MeterReadingLoaded;
    
    try {
      emit(MeterReadingLoading());
      
      final selectedProp = currentState.properties.firstWhere((p) => p.id == propertyId);
      
      final roomsTask = _roomRepository.getRoomsByProperty(propertyId);
      final readingsTask = _meterReadingRepository.getMeterReadingsByProperty(propertyId);
      
      final results = await Future.wait([roomsTask, readingsTask]);
      final rooms = results[0] as List<Room>;
      final readings = results[1] as List<MeterReading>;
      
      final entries = rooms.map((room) {
        double prevEl = 0;
        double prevWa = 0;
        
        // Find latest meter reading for this room
        final roomReadings = readings.where((r) => r.roomId == room.id).toList();
        roomReadings.sort((a, b) {
          if (a.year != b.year) return b.year.compareTo(a.year);
          return b.month.compareTo(a.month);
        });

        for (var r in roomReadings) {
          if (r.type == MeterType.electricity && prevEl == 0) prevEl = r.newUnit;
          if (r.type == MeterType.water && prevWa == 0) prevWa = r.newUnit;
        }

        return RoomMeterEntry(
          roomId: room.id,
          roomName: room.name,
          tenant: room.status == RoomStatus.occupied ? 'Đang thuê' : 'Trống',
          basePrice: room.basePrice,
          prevElectric: prevEl,
          curElectric: 0,
          prevWater: prevWa,
          curWater: 0,
          electricRate: 3500, // Hardcoded per user request context
          waterRate: 15000,   // Hardcoded per user request context
        );
      }).toList();

      emit(MeterReadingLoaded(
        properties: currentState.properties,
        selectedProperty: selectedProp,
        entries: entries,
      ));
    } catch (e) {
      if (e is AppException) {
        emit(MeterReadingError(e.message));
      } else {
        emit(MeterReadingError(e.toString()));
      }
    }
  }

  void updateMeterValue(String roomId, {double? elValue, double? waValue}) {
    if (state is! MeterReadingLoaded) return;
    final currentState = state as MeterReadingLoaded;
    
    final updatedEntries = currentState.entries.map((entry) {
      if (entry.roomId == roomId) {
        return entry.copyWith(
          curElectric: elValue ?? entry.curElectric,
          curWater: waValue ?? entry.curWater,
        );
      }
      return entry;
    }).toList();
    
    emit(currentState.copyWith(entries: updatedEntries));
  }
  
  void markRoomDoneLocally(String roomId) {
    if (state is! MeterReadingLoaded) return;
    final currentState = state as MeterReadingLoaded;
    
    final updatedEntries = currentState.entries.map((entry) {
      if (entry.roomId == roomId) {
        return entry.copyWith(isDone: true);
      }
      return entry;
    }).toList();
    
    emit(currentState.copyWith(entries: updatedEntries));
  }

  Future<void> submitBatch() async {
    if (state is! MeterReadingLoaded) return;
    final currentState = state as MeterReadingLoaded;
    final doneEntries = currentState.entries.where((e) => e.isDone).toList();
    
    if (doneEntries.isEmpty) return;
    
    emit(MeterReadingLoading());
    try {
      final now = DateTime.now();
      
      for (final entry in doneEntries) {
        // Electricity
        if (entry.curElectric > entry.prevElectric) {
          await _meterReadingRepository.createMeterReading(
            entry.roomId,
            "Electricity",
            entry.prevElectric,
            entry.curElectric,
            now.month,
            now.year,
          );
        }
        
        // Water
        if (entry.curWater > entry.prevWater) {
          await _meterReadingRepository.createMeterReading(
            entry.roomId,
            "Water",
            entry.prevWater,
            entry.curWater,
            now.month,
            now.year,
          );
        }
      }
      
      // Reload after submit
      if (currentState.selectedProperty != null) {
        emit(MeterReadingLoaded(
          properties: currentState.properties,
          selectedProperty: currentState.selectedProperty,
          entries: currentState.entries,
        ));
        await selectProperty(currentState.selectedProperty!.id);
      }
      
    } catch (e) {
      if (e is AppException) {
        emit(MeterReadingError(e.message));
      } else {
        emit(MeterReadingError(e.toString()));
      }
    }
  }
}
