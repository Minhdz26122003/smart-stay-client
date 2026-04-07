// lib/features/meter_reading/presentation/cubit/meter_reading_state.dart

import 'package:equatable/equatable.dart';

import '../../../property/domain/entities/property.dart';
class RoomMeterEntry extends Equatable {
  final String roomId;
  final String roomName;
  final String tenant;
  final double basePrice;
  final double prevElectric;
  final double curElectric;
  final double prevWater;
  final double curWater;
  final double electricRate;
  final double waterRate;
  final bool isDone;

  const RoomMeterEntry({
    required this.roomId,
    required this.roomName,
    required this.tenant,
    required this.basePrice,
    required this.prevElectric,
    required this.curElectric,
    required this.prevWater,
    required this.curWater,
    required this.electricRate,
    required this.waterRate,
    this.isDone = false,
  });

  RoomMeterEntry copyWith({
    String? roomId,
    String? roomName,
    String? tenant,
    double? basePrice,
    double? prevElectric,
    double? curElectric,
    double? prevWater,
    double? curWater,
    double? electricRate,
    double? waterRate,
    bool? isDone,
  }) {
    return RoomMeterEntry(
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      tenant: tenant ?? this.tenant,
      basePrice: basePrice ?? this.basePrice,
      prevElectric: prevElectric ?? this.prevElectric,
      curElectric: curElectric ?? this.curElectric,
      prevWater: prevWater ?? this.prevWater,
      curWater: curWater ?? this.curWater,
      electricRate: electricRate ?? this.electricRate,
      waterRate: waterRate ?? this.waterRate,
      isDone: isDone ?? this.isDone,
    );
  }

  double get electricUsed => curElectric - prevElectric;
  double get waterUsed => curWater - prevWater;
  double get electricCost => electricUsed * electricRate;
  double get waterCost => waterUsed * waterRate;
  double get total => basePrice + electricCost + waterCost;

  @override
  List<Object?> get props => [
        roomId,
        roomName,
        tenant,
        basePrice,
        prevElectric,
        curElectric,
        prevWater,
        curWater,
        electricRate,
        waterRate,
        isDone,
      ];
}

class MeterReadingState extends Equatable {
  const MeterReadingState();

  @override
  List<Object?> get props => [];
}

class MeterReadingInitial extends MeterReadingState {}

class MeterReadingLoading extends MeterReadingState {}

class MeterReadingLoaded extends MeterReadingState {
  final List<Property> properties;
  final Property? selectedProperty;
  final List<RoomMeterEntry> entries;

  const MeterReadingLoaded({
    required this.properties,
    this.selectedProperty,
    required this.entries,
  });

  MeterReadingLoaded copyWith({
    List<Property>? properties,
    Property? selectedProperty,
    List<RoomMeterEntry>? entries,
  }) {
    return MeterReadingLoaded(
      properties: properties ?? this.properties,
      selectedProperty: selectedProperty ?? this.selectedProperty,
      entries: entries ?? this.entries,
    );
  }

  @override
  List<Object?> get props => [properties, selectedProperty, entries];
}

class MeterReadingError extends MeterReadingState {
  final String message;

  const MeterReadingError(this.message);

  @override
  List<Object?> get props => [message];
}
