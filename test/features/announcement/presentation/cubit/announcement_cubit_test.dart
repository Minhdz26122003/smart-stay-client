import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_stay_client/core/network/app_exception.dart';
import 'package:smart_stay_client/features/announcement/domain/entities/announcement.dart';
import 'package:smart_stay_client/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:smart_stay_client/features/announcement/presentation/cubit/announcement_cubit.dart';
import 'package:smart_stay_client/features/announcement/presentation/cubit/announcement_state.dart';

class _MockAnnouncementRepository extends Mock
    implements AnnouncementRepository {}

void main() {
  late AnnouncementRepository repository;
  late AnnouncementCubit cubit;

  const propertyId = 'property-1';
  const announcementId = 'announcement-1';

  final existing = [
    Announcement(
      id: announcementId,
      propertyId: propertyId,
      title: 'Notice 1',
      body: 'Body 1',
      createdByName: 'Owner A',
      createdAt: DateTime(2026, 5, 15),
      isPinned: false,
    ),
    Announcement(
      id: 'announcement-2',
      propertyId: propertyId,
      title: 'Notice 2',
      body: 'Body 2',
      createdByName: 'Owner B',
      createdAt: DateTime(2026, 5, 14),
      isPinned: true,
    ),
  ];

  final refreshed = [existing.last];

  setUp(() {
    repository = _MockAnnouncementRepository();
    cubit = AnnouncementCubit(repository: repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  blocTest<AnnouncementCubit, AnnouncementState>(
    'emits delete progress and refreshed loaded state when delete succeeds',
    build: () {
      when(() => repository.deleteAnnouncement(announcementId))
          .thenAnswer((_) async {});
      when(() => repository.getAnnouncementsByProperty(propertyId))
          .thenAnswer((_) async => refreshed);
      return cubit;
    },
    seed: () => AnnouncementLoaded(
      announcements: existing,
      propertyId: propertyId,
    ),
    act: (cubit) => cubit.deleteAnnouncement(announcementId, propertyId),
    expect: () => [
      isA<AnnouncementDeleteInProgress>()
          .having((s) => s.deletingAnnouncementId, 'deletingAnnouncementId',
              announcementId)
          .having((s) => s.announcements, 'announcements', existing),
      isA<AnnouncementLoaded>()
          .having((s) => s.announcements, 'announcements', refreshed)
          .having((s) => s.propertyId, 'propertyId', propertyId),
    ],
  );

  blocTest<AnnouncementCubit, AnnouncementState>(
    'emits delete error state when delete fails',
    build: () {
      when(() => repository.deleteAnnouncement(announcementId)).thenThrow(
        const AppException('Delete failed'),
      );
      return cubit;
    },
    seed: () => AnnouncementLoaded(
      announcements: existing,
      propertyId: propertyId,
    ),
    act: (cubit) => cubit.deleteAnnouncement(announcementId, propertyId),
    expect: () => [
      isA<AnnouncementDeleteInProgress>()
          .having((s) => s.deletingAnnouncementId, 'deletingAnnouncementId',
              announcementId),
      isA<AnnouncementDeleteError>()
          .having((s) => s.message, 'message', 'Delete failed')
          .having((s) => s.announcements, 'announcements', existing),
    ],
  );
}
