// lib/features/property/presentation/cubit/property_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/property_repository.dart';
import 'property_state.dart';
import '../../../../core/network/app_exception.dart';

class PropertyCubit extends Cubit<PropertyState> {
  final PropertyRepository _repository;

  PropertyCubit({required PropertyRepository repository})
      : _repository = repository,
        super(const PropertyState.initial());

  Future<void> loadProperties() async {
    emit(const PropertyState.loading());
    try {
      final properties = await _repository.getProperties();
      emit(PropertyState.loaded(
        properties,
        properties.isNotEmpty ? properties.first : null,
      ));
    } on AppException catch (e) {
      emit(PropertyState.error(e.message));
    } catch (e) {
      emit(PropertyState.error(e.toString()));
    }
  }

  void selectProperty(String? propertyId) {
    state.maybeWhen(
      loaded: (properties, current) {
        if (propertyId == null) {
          emit(PropertyState.loaded(properties, null));
          return;
        }
        try {
          final selected = properties.firstWhere((p) => p.id == propertyId);
          emit(PropertyState.loaded(properties, selected));
        } catch (_) {
          // ignore if not found
        }
      },
      orElse: () {},
    );
  }

  Future<void> deleteProperty(String id) async {
    final currentState = state;
    emit(const PropertyState.deleteLoading());
    try {
      await _repository.deleteProperty(id);
      emit(const PropertyState.deleteSuccess());
      // Refresh list
      await loadProperties();
    } on AppException catch (e) {
      emit(PropertyState.deleteError(e.message));
      emit(currentState); // Restore previous state
    } catch (e) {
      emit(PropertyState.deleteError(e.toString()));
      emit(currentState); // Restore previous state
    }
  }
}
