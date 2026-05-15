import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/announcement/presentation/cubit/announcement_cubit.dart';
import '../../../../features/announcement/presentation/cubit/announcement_state.dart';
import '../../../../features/announcement/domain/entities/announcement.dart';
import '../../../../features/property/presentation/cubit/property_cubit.dart';
import '../../../../features/property/presentation/cubit/property_state.dart';
import '../../../../core/di/injection_container.dart';

class LandlordBoardScreen extends StatelessWidget {
  const LandlordBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, propState) {
        // Get first property ID to load announcements
        final propertyId = propState.maybeWhen(
          loaded: (props, selected) =>
              selected?.id ?? (props.isNotEmpty ? props.first.id : null),
          orElse: () => null,
        );

        if (propertyId == null) {
          return const Scaffold(
            body: Center(child: Text('Không tìm thấy khu trọ')),
          );
        }

        return BlocProvider(
          create: (_) =>
              sl<AnnouncementCubit>()..loadByProperty(propertyId),
          child: _BoardContent(propertyId: propertyId),
        );
      },
    );
  }
}

class _BoardContent extends StatefulWidget {
  final String propertyId;
  const _BoardContent({required this.propertyId});

  @override
  State<_BoardContent> createState() => _BoardContentState();
}

class _BoardContentState extends State<_BoardContent> {
  int _tabIdx = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return BlocConsumer<AnnouncementCubit, AnnouncementState>(
      listenWhen: (previous, current) {
        return current is AnnouncementDeleteError ||
            (previous is AnnouncementDeleteInProgress &&
                current is AnnouncementLoaded);
      },
      listener: (context, state) {
        if (state is AnnouncementDeleteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa bài viết'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      builder: (context, state) {
        final announcements =
            state is AnnouncementLoaded ? state.announcements : <Announcement>[];
        final deletingAnnouncementId = state is AnnouncementDeleteInProgress
            ? state.deletingAnnouncementId
            : null;

        final filtered = _tabIdx == 0
            ? announcements
            : announcements.where((a) => a.isPinned).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF1F4FF),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: cs.onSurface),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Bảng tin khu trọ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.campaign_rounded, color: cs.primary, size: 26),
                onPressed: () async {
                  await context.push(
                    '/landlord/add-board-post',
                    extra: widget.propertyId,
                  );
                  // Refresh after returning
                  if (context.mounted) {
                    context
                        .read<AnnouncementCubit>()
                        .loadByProperty(widget.propertyId);
                  }
                },
                tooltip: 'Đăng thông báo',
              ),
            ],
          ),
          body: Column(
            children: [
              // ── Filter Tabs ──────────────────────────────────────────────
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _TabChip(
                      label: 'Tất cả (${announcements.length})',
                      selected: _tabIdx == 0,
                      onTap: () => setState(() => _tabIdx = 0),
                      cs: cs,
                    ),
                    const SizedBox(width: 8),
                    _TabChip(
                      label:
                          'Đã ghim (${announcements.where((a) => a.isPinned).length})',
                      selected: _tabIdx == 1,
                      onTap: () => setState(() => _tabIdx = 1),
                      cs: cs,
                    ),
                  ],
                ),
              ),

              // ── Content ─────────────────────────────────────────────────
              Expanded(
                child: state is AnnouncementLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is AnnouncementError
                        ? _ErrorView(
                            message: state.message,
                            onRetry: () => context
                                .read<AnnouncementCubit>()
                                .loadByProperty(widget.propertyId),
                          )
                        : filtered.isEmpty
                            ? _EmptyView(cs: cs)
                            : RefreshIndicator(
                                onRefresh: () => context
                                    .read<AnnouncementCubit>()
                                    .loadByProperty(widget.propertyId),
                                child: ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 12, 16, 24),
                                  itemCount: filtered.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (ctx, i) => _PostCard(
                                    announcement: filtered[i],
                                    cs: cs,
                                    theme: theme,
                                    isDeleting: deletingAnnouncementId ==
                                        filtered[i].id,
                                    onDelete: () => context
                                        .read<AnnouncementCubit>()
                                        .deleteAnnouncement(
                                          filtered[i].id,
                                          widget.propertyId,
                                        ),
                                  ),
                                ),
                              ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Tab Chip ────────────────────────────────────────────────────────────────
class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme cs;

  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? cs.primary : const Color(0xFFF1F4FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? Colors.white : cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

// ─── Post Card ────────────────────────────────────────────────────────────────
class _PostCard extends StatefulWidget {
  final Announcement announcement;
  final ColorScheme cs;
  final ThemeData theme;
  final bool isDeleting;
  final VoidCallback onDelete;

  const _PostCard({
    required this.announcement,
    required this.cs,
    required this.theme,
    required this.isDeleting,
    required this.onDelete,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.announcement;
    final cs = widget.cs;
    final theme = widget.theme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: p.isPinned
            ? Border.all(color: cs.primary.withValues(alpha: 0.5), width: 1.5)
            : Border.all(color: Colors.transparent),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Author Info ─────────────────────────────────────────────
          Row(children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: cs.primaryContainer,
              child: Text(
                p.initials,
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.createdByName,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    p.timeAgoLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: cs.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (p.isPinned)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  Icon(Icons.push_pin_rounded,
                      size: 12, color: Colors.amber.shade900),
                  const SizedBox(width: 4),
                  Text(
                    'Ghim',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ]),
              ),
            // Delete button
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: widget.isDeleting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cs.primary,
                      ),
                    )
                  : Icon(Icons.more_vert_rounded,
                      size: 20, color: cs.onSurface.withValues(alpha: 0.4)),
              onPressed: widget.isDeleting
                  ? null
                  : () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.delete_outline_rounded,
                              color: Colors.red.shade400),
                          title: Text('Xóa bài viết',
                              style:
                                  TextStyle(color: Colors.red.shade500)),
                          onTap: () async {
                            Navigator.pop(context);
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Xóa bài viết'),
                                content: const Text(
                                  'Bạn có chắc muốn xóa bài viết này không?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, false),
                                    child: const Text('Hủy'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, true),
                                    child: const Text('Xóa'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true && context.mounted) {
                              widget.onDelete();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ]),
          const SizedBox(height: 14),

          // ── Title & Content ─────────────────────────────────────────
          Text(
            p.title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w800, height: 1.3),
          ),
          const SizedBox(height: 8),
          Text(
            p.body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // ── Interaction ─────────────────────────────────────────────
          Row(children: [
            GestureDetector(
              onTap: () => setState(() => _liked = !_liked),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _liked ? Colors.red.shade50 : const Color(0xFFF1F4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  Icon(
                    _liked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 16,
                    color: _liked
                        ? Colors.red.shade500
                        : cs.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _liked ? '1' : '0',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _liked
                          ? Colors.red.shade500
                          : cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

// ─── Empty & Error Views ──────────────────────────────────────────────────────
class _EmptyView extends StatelessWidget {
  final ColorScheme cs;
  const _EmptyView({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.campaign_outlined,
              size: 64, color: cs.onSurface.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Text('Chưa có thông báo nào',
              style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.4), fontSize: 15)),
          const SizedBox(height: 8),
          Text('Nhấn vào 📣 để đăng thông báo đầu tiên!',
              style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.3), fontSize: 13)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}
