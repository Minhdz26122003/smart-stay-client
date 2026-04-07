// lib/features/announcement/presentation/cubit/announcement_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/app_exception.dart';
import '../../domain/repositories/announcement_repository.dart';
import 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementRepository _repository;

  AnnouncementCubit({required AnnouncementRepository repository})
      : _repository = repository,
        super(AnnouncementInitial());

  Future<void> loadByProperty(String propertyId) async {
    try {
      emit(AnnouncementLoading());
      final announcements =
          await _repository.getAnnouncementsByProperty(propertyId);
      emit(AnnouncementLoaded(
          announcements: announcements, propertyId: propertyId));
    } catch (e) {
      final msg = e is AppException ? e.message : e.toString();
      emit(AnnouncementError(msg));
    }
  }

  Future<void> postAnnouncement({
    required String propertyId,
    required String title,
    required String body,
  }) async {
    try {
      emit(AnnouncementSubmitting());
      await _repository.createAnnouncement(
        propertyId: propertyId,
        title: title,
        body: body,
      );
      emit(AnnouncementSubmitSuccess(propertyId));
      // Reload list after posting
      await loadByProperty(propertyId);
    } catch (e) {
      final msg = e is AppException ? e.message : e.toString();
      emit(AnnouncementSubmitError(msg));
    }
  }

  Future<void> deleteAnnouncement(String id, String propertyId) async {
    try {
      await _repository.deleteAnnouncement(id);
      await loadByProperty(propertyId);
    } catch (e) {
      final msg = e is AppException ? e.message : e.toString();
      emit(AnnouncementError(msg));
    }
  }
}
