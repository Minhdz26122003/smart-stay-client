// lib/features/announcement/domain/entities/announcement.dart

class Announcement {
  final String id;
  final String propertyId;
  final String title;
  final String body;
  final String createdByName;
  final DateTime createdAt;
  final bool isPinned;

  const Announcement({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.body,
    required this.createdByName,
    required this.createdAt,
    required this.isPinned,
  });

  String get timeAgoLabel {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays == 1) return 'Hôm qua';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  String get initials {
    final parts = createdByName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
    }
    return createdByName.substring(0, 1).toUpperCase();
  }
}
