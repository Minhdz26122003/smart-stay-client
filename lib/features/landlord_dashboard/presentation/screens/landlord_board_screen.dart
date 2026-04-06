import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandlordBoardScreen extends StatefulWidget {
  const LandlordBoardScreen({super.key});
  @override
  State<LandlordBoardScreen> createState() => _LandlordBoardScreenState();
}

class _LandlordBoardScreenState extends State<LandlordBoardScreen> {
  int _tabIdx = 0; // 0: Tất cả, 1: Thông báo, 2: Khảo sát

  static const _posts = [
    _PostData(
      id: '1',
      type: 'alert',
      author: 'Ban Quản Lý',
      initials: 'QL',
      timeAgo: '2 giờ trước',
      title: 'Thông báo lịch cắt nước bảo trì định kỳ',
      body:
          'Kính gửi anh/chị, để đảm bảo hệ thống cấp nước hoạt động ổn định trong mùa khô sắp tới, ban quản lý sẽ tiến hành súc rửa và bảo trì bể chứa nước tổng vào sáng Thứ Bảy tuần này (Từ 8h00 đến 11h30). Mọi người vui lòng chủ động tích trữ nước sinh hoạt. Xin cảm ơn!',
      isPinned: true,
      likes: 12,
      comments: 3,
    ),
    _PostData(
      id: '2',
      type: 'survey',
      author: 'Chủ nhà',
      initials: 'CN',
      timeAgo: 'Hôm qua',
      title: 'Khảo sát lắp thêm máy sấy quần áo chung',
      body:
          'Nhận thấy nhu cầu phơi đồ mùa mưa gặp nhiều khó khăn, tôi dự định lắp thêm 2 máy sấy quần áo công nghiệp tại khu vực sân thượng. Phí sử dụng dự kiến 15k/lần sấy. Mong các bạn cho ý kiến khảo sát để tôi đưa ra quyết định.',
      isPinned: false,
      likes: 8,
      comments: 5,
      surveyOptions: [
        {'label': 'Rất cần thiết, nên lắp ngay', 'votes': 15, 'percent': 0.6},
        {'label': 'Cũng được, thi thoảng dùng', 'votes': 7, 'percent': 0.28},
        {'label': 'Không cần thiết', 'votes': 3, 'percent': 0.12},
      ],
      totalVotes: 25,
      myVoteIdx: null,
    ),
    _PostData(
      id: '3',
      type: 'info',
      author: 'Kỹ thuật viên Tùng',
      initials: 'KT',
      timeAgo: '3 ngày trước',
      title: 'Mẹo tiết kiệm điện năng trong mùa hè',
      body:
          'Để giảm chi phí hóa đơn điện, các bạn nên vệ sinh lưới lọc điều hòa định kỳ 2 tuần 1 lần. Mức nhiệt độ tối ưu nên cài đặt là khoảng 26-27 độ C, kết hợp bật quạt gió nhẹ. Tránh bật tắt máy lạnh liên tục sẽ gây tốn điện năng hơn rất nhiều.',
      isPinned: false,
      likes: 24,
      comments: 7,
    ),
  ];

  List<_PostData> get _filteredPosts {
    if (_tabIdx == 0) return _posts;
    if (_tabIdx == 1) return _posts.where((p) => p.type != 'survey').toList();
    return _posts.where((p) => p.type == 'survey').toList();
  }

  // Removed controllers usage

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
            icon: Icon(
              Icons.campaign_rounded,
              color: cs.primary,
              size: 26,
            ),
            onPressed: () => context.push('/landlord/add-board-post'),
            tooltip: 'Đăng thông báo',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Filter Tabs ─────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TabChip(
                    label: 'Tất cả (${_posts.length})',
                    selected: _tabIdx == 0,
                    onTap: () => setState(() => _tabIdx = 0),
                    cs: cs,
                  ),
                  const SizedBox(width: 8),
                  _TabChip(
                    label:
                        'Thông báo (${_posts.where((p) => p.type != 'survey').length})',
                    selected: _tabIdx == 1,
                    onTap: () => setState(() => _tabIdx = 1),
                    cs: cs,
                  ),
                  const SizedBox(width: 8),
                  _TabChip(
                    label:
                        'Khảo sát (${_posts.where((p) => p.type == 'survey').length})',
                    selected: _tabIdx == 2,
                    onTap: () => setState(() => _tabIdx = 2),
                    cs: cs,
                  ),
                ],
              ),
            ),
          ),

          // ── Post List ──────────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: _filteredPosts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final post = _filteredPosts[i];
                return _PostCard(post: post, cs: cs, theme: theme);
              },
            ),
          ),
        ],
      ),
    );
  }
}

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

class _PostData {
  final String id, type, author, initials, timeAgo, title, body;
  final bool isPinned;
  final int likes, comments;
  final List<Map<String, dynamic>>? surveyOptions;
  final int? totalVotes;
  final int? myVoteIdx;

  const _PostData({
    required this.id,
    required this.type,
    required this.author,
    required this.initials,
    required this.timeAgo,
    required this.title,
    required this.body,
    required this.isPinned,
    required this.likes,
    required this.comments,
    this.surveyOptions,
    this.totalVotes,
    this.myVoteIdx,
  });
}

class _PostCard extends StatefulWidget {
  final _PostData post;
  final ColorScheme cs;
  final ThemeData theme;

  const _PostCard({
    required this.post,
    required this.cs,
    required this.theme,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _liked = false;
  int? _votedIdx;

  @override
  void initState() {
    super.initState();
    _votedIdx = widget.post.myVoteIdx;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Author Info ────────────────────────────────────────────────
          Row(children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: p.type == 'survey'
                  ? Colors.blue.shade100
                  : cs.primaryContainer,
              child: Text(
                p.initials,
                style: TextStyle(
                  color: p.type == 'survey' ? Colors.blue.shade700 : cs.primary,
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
                  Row(
                    children: [
                      Text(
                        p.author,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (p.author.contains('Quản lý')) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified_rounded,
                            size: 14, color: Colors.blue.shade600),
                      ]
                    ],
                  ),
                  Text(
                    p.timeAgo,
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
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
                  ],
                ),
              ),
            if (p.type == 'survey')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Khảo sát',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 14),

          // ── Title & Content ────────────────────────────────────────────
          Text(
            p.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
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

          // ── Survey block ───────────────────────────────────────────────
          if (p.type == 'survey' && p.surveyOptions != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.primary.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < p.surveyOptions!.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    _SurveyOption(
                      label: p.surveyOptions![i]['label'],
                      percent: p.surveyOptions![i]['percent'],
                      votes: p.surveyOptions![i]['votes'],
                      isSelected: _votedIdx == i,
                      hasVoted: _votedIdx != null,
                      onTap: () {
                        if (_votedIdx == null) {
                          setState(() => _votedIdx = i);
                        }
                      },
                      cs: cs,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.how_to_vote_rounded,
                          size: 14, color: cs.onSurface.withValues(alpha: 0.5)),
                      const SizedBox(width: 4),
                      Text(
                        '${p.totalVotes! + (_votedIdx != null ? 1 : 0)} lượt bình chọn',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Interaction Action ─────────────────────────────────────────
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _liked = !_liked),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _liked ? Colors.red.shade50 : const Color(0xFFF1F4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 16,
                        color: _liked ? Colors.red.shade500 : cs.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${p.likes + (_liked ? 1 : 0)}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _liked ? Colors.red.shade500 : cs.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.mode_comment_outlined,
                      size: 16,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${p.comments}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                isSelected: false,
                selectedIcon: Icon(Icons.bookmark_rounded, color: cs.primary),
                icon: Icon(Icons.bookmark_border_rounded,
                    color: cs.onSurface.withValues(alpha: 0.4)),
                onPressed: () {},
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class _SurveyOption extends StatelessWidget {
  final String label;
  final double percent;
  final int votes;
  final bool isSelected;
  final bool hasVoted;
  final VoidCallback onTap;
  final ColorScheme cs;

  const _SurveyOption({
    required this.label,
    required this.percent,
    required this.votes,
    required this.isSelected,
    required this.hasVoted,
    required this.onTap,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? cs.primary
                : cs.onSurface.withValues(alpha: 0.1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Progress Bar
            if (hasVoted)
              FractionallySizedBox(
                widthFactor: percent,
                heightFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? cs.primary.withValues(alpha: 0.15)
                        : const Color(0xFFF1F4FF),
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? cs.primary : cs.onSurface,
                      ),
                    ),
                  ),
                  if (hasVoted) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${(percent * 100).round()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
