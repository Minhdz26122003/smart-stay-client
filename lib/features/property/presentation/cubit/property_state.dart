// lib/features/property/presentation/cubit/property_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/property.dart';

part 'property_state.freezed.dart';

@freezed
class PropertyState with _$PropertyState {
  const factory PropertyState.initial() = _Initial;
  const factory PropertyState.loading() = _Loading;
  const factory PropertyState.loaded(List<Property> properties, Property? selectedProperty) = _Loaded;
  const factory PropertyState.error(String message) = _Error;
}
