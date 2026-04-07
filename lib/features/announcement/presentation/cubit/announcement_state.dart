// lib/features/announcement/presentation/cubit/announcement_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/announcement.dart';

abstract class AnnouncementState extends Equatable {
  const AnnouncementState();
  @override
  List<Object?> get props => [];
}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementLoading extends AnnouncementState {}

class AnnouncementLoaded extends AnnouncementState {
  final List<Announcement> announcements;
  final String propertyId;

  const AnnouncementLoaded({
    required this.announcements,
    required this.propertyId,
  });

  @override
  List<Object?> get props => [announcements, propertyId];
}

class AnnouncementError extends AnnouncementState {
  final String message;
  const AnnouncementError(this.message);
  @override
  List<Object?> get props => [message];
}

class AnnouncementSubmitting extends AnnouncementState {}

class AnnouncementSubmitSuccess extends AnnouncementState {
  final String propertyId;
  const AnnouncementSubmitSuccess(this.propertyId);
  @override
  List<Object?> get props => [propertyId];
}

class AnnouncementSubmitError extends AnnouncementState {
  final String message;
  const AnnouncementSubmitError(this.message);
  @override
  List<Object?> get props => [message];
}
