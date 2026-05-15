// lib/features/announcement/presentation/cubit/announcement_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/app_exception.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementRepository _repository;

  AnnouncementCubit({required AnnouncementRepository repository})
      : _repository = repository,
        super(AnnouncementInitial());

  Future<void> loadByProperty(String propertyId) async {
    try {
      if (isClosed) return;
      emit(AnnouncementLoading());
      final announcements =
          await _repository.getAnnouncementsByProperty(propertyId);
      if (isClosed) return;
      emit(AnnouncementLoaded(
          announcements: announcements, propertyId: propertyId));
    } catch (e) {
      final msg = e is AppException ? e.message : e.toString();
      if (isClosed) return;
      emit(AnnouncementError(msg));
    }
  }

  Future<void> postAnnouncement({
    required String propertyId,
    required String title,
    required String body,
  }) async {
    try {
      if (isClosed) return;
      emit(AnnouncementSubmitting());
      await _repository.createAnnouncement(
        propertyId: propertyId,
        title: title,
        body: body,
      );
      if (isClosed) return;
      emit(AnnouncementSubmitSuccess(propertyId));
    } catch (e) {
      final msg = e is AppException ? e.message : e.toString();
      if (isClosed) return;
      emit(AnnouncementSubmitError(msg));
    }
  }

  Future<void> deleteAnnouncement(String id, String propertyId) async {
    final currentState = state;
    final currentAnnouncements = currentState is AnnouncementLoaded
        ? currentState.announcements
        : <Announcement>[];

    try {
      if (currentState is AnnouncementLoaded) {
        if (isClosed) return;
        emit(AnnouncementDeleteInProgress(
          announcements: currentState.announcements,
          propertyId: currentState.propertyId,
          deletingAnnouncementId: id,
        ));
      }
      await _repository.deleteAnnouncement(id);
      final announcements =
          await _repository.getAnnouncementsByProperty(propertyId);
      if (isClosed) return;
      emit(AnnouncementLoaded(
        announcements: announcements,
        propertyId: propertyId,
      ));
    } catch (e) {
      final msg = e is AppException ? e.message : e.toString();
      if (currentState is AnnouncementLoaded) {
        if (isClosed) return;
        emit(AnnouncementDeleteError(
          announcements: currentAnnouncements,
          propertyId: currentState.propertyId,
          message: msg,
        ));
        return;
      }
      if (isClosed) return;
      emit(AnnouncementError(msg));
    }
  }
}
