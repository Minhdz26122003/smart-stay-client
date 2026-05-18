import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../property/presentation/cubit/property_cubit.dart';
import '../../../property/presentation/cubit/property_state.dart';
import '../../../statistics/presentation/cubit/finance_summary_cubit.dart';
import '../../../statistics/presentation/cubit/finance_summary_state.dart';

class LandlordHomeScreen extends StatelessWidget {
  const LandlordHomeScreen({super.key});

  String _formatVnd(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1).replaceAll('.0', '')}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userName = state.maybeWhen(
          authenticated: (user) => user.fullName,
          orElse: () => 'Anh Hùng', // Default as per design
        );

        return BlocListener<PropertyCubit, PropertyState>(
          listener: (context, propertyState) {
            propertyState.maybeWhen(
              deleteLoading: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
              },
              deleteSuccess: () {
                context.pop(); // Close loading
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa khu trọ thành công')),
                );
              },
              deleteError: (msg) {
                context.pop(); // Close loading
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi: $msg'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              orElse: () {},
            );
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF8F9FF), // Very light background
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Smart Stay',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              Text(
                                'Xin chào, $userName',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: colorScheme.primaryContainer,
                              backgroundImage: const NetworkImage(
                                'https://i.pravatar.cc/150?img=11',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Area Filter Chips
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BlocBuilder<PropertyCubit, PropertyState>(
                        builder: (context, propertyState) {
                          final properties = propertyState.maybeWhen(
                            loaded: (props, selected) => props,
                            orElse: () => [],
                          );
                          final selectedProperty = propertyState.maybeWhen(
                            loaded: (props, selected) => selected,
                            orElse: () => null,
                          );

                          return Row(
                            children: [
                              // _AreaChip(
                              //   label: 'Tất cả khu trọ',
                              //   isSelected: selectedProperty == null,
                              //   onTap: () {
                              //     context.read<PropertyCubit>().selectProperty(
                              //       null,
                              //     );
                              //     context
                              //         .read<FinanceSummaryCubit>()
                              //         .loadFinanceSummary(propertyId: null);
                              //   },
                              // ),
                              if (properties.isNotEmpty)
                                ...properties.map(
                                  (p) => Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: _AreaChip(
                                      label: p.name,
                                      isSelected: selectedProperty?.id == p.id,
                                      onTap: () {
                                        context
                                            .read<PropertyCubit>()
                                            .selectProperty(p.id);
                                        context
                                            .read<FinanceSummaryCubit>()
                                            .loadFinanceSummary(
                                              propertyId: p.id,
                                            );
                                      },
                                      onLongPress: () {
                                        _showDeletePropertyDialog(
                                          context,
                                          p.id,
                                          p.name,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  // Stats Grid
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    sliver:
                        BlocBuilder<FinanceSummaryCubit, FinanceSummaryState>(
                          builder: (context, financeState) {
                            if (financeState is FinanceSummaryLoaded) {
                              final summary = financeState.summary;
                              final occupiedPercent = summary.totalRooms > 0
                                  ? (summary.occupiedRooms /
                                            summary.totalRooms *
                                            100)
                                        .toStringAsFixed(0)
                                  : '0';
                              return SliverGrid.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.15,
                                children: [
                                  _StatCard(
                                    title: 'PHÒNG TRỐNG',
                                    icon: Icons.home_rounded,
                                    iconColor: Colors.orange,
                                    mainValue: summary.emptyRooms.toString(),
                                    mainValueColor: Colors.orange,
                                    subValueWidget: Text(
                                      ' / ${summary.totalRooms} phòng',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  _StatCard(
                                    title: 'ĐANG THUÊ',
                                    icon: Icons.check_circle_rounded,
                                    iconColor: colorScheme.primary,
                                    mainValue: summary.occupiedRooms.toString(),
                                    mainValueColor: colorScheme.primary,
                                    subValueWidget: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'tỷ lệ lấp đầy $occupiedPercent%',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  _StatCard(
                                    title: 'DOANH THU',
                                    icon: Icons.payments_rounded,
                                    iconColor: colorScheme.primary,
                                    mainValue: _formatVnd(summary.totalRevenue),
                                    mainValueColor: colorScheme.primary,
                                    subValueWidget: Row(
                                      children: [
                                        Icon(
                                          Icons.trending_up_rounded,
                                          size: 14,
                                          color: colorScheme.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          'Dữ liệu T4',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _StatCard(
                                    title: 'CHƯA THU',
                                    icon: Icons.warning_rounded,
                                    iconColor: Colors.red,
                                    mainValue: _formatVnd(summary.unpaidAmount),
                                    mainValueColor: Colors.red,
                                    subValueWidget: const Text(
                                      'các hợp đồng',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            if (financeState is FinanceSummaryError) {
                              return SliverToBoxAdapter(
                                child: Center(
                                  child: Text('Lỗi: ${financeState.message}'),
                                ),
                              );
                            }

                            // Show Skeletons during loading
                            return SliverGrid.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.15,
                              children: const [
                                _StatCardSkeleton(),
                                _StatCardSkeleton(),
                                _StatCardSkeleton(),
                                _StatCardSkeleton(),
                              ],
                            );
                          },
                        ),
                  ),

                  // Alert Banners
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _AlertBanner(
                            icon: Icons.timer,
                            iconColor: Colors.orange.shade700,
                            text: '3 hợp đồng sắp hết hạn\ntrong 30 ngày',
                            actionText: 'NHẤN XEM',
                            backgroundColor: Colors.orange.shade50.withValues(
                              alpha: 0.5,
                            ),
                            borderColor: Colors.orange.shade200,
                            textColor: Colors.orange.shade900,
                          ),
                          const SizedBox(height: 12),
                          _AlertBanner(
                            icon: Icons.error_outline_rounded,
                            iconColor: Colors.red.shade600,
                            text: '5 phòng chưa đóng tiền • Quá hạn 5\nngày',
                            actionIcon: Icons.chevron_right_rounded,
                            backgroundColor: Colors.red.shade50.withValues(
                              alpha: 0.5,
                            ),
                            borderColor: Colors.red.shade100,
                            textColor: Colors.red.shade900,
                          ),
                          const SizedBox(height: 12),
                          _AlertBanner(
                            icon: Icons.build_rounded,
                            iconColor: colorScheme.primary,
                            text: '2 sự cố mới cần xử lý hôm nay',
                            actionIcon: Icons.chevron_right_rounded,
                            backgroundColor: colorScheme.primaryContainer
                                .withValues(alpha: 0.1),
                            borderColor: colorScheme.primary.withValues(
                              alpha: 0.2,
                            ),
                            textColor: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Quick Actions
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TIỆN ÍCH NHANH',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _QuickAction(
                                icon: Icons.camera_alt_rounded,
                                label: 'Chốt điện\nnước',
                                onTap: () =>
                                    context.push('/landlord/finance/settle'),
                              ),
                              _QuickAction(
                                icon: Icons.add_circle_rounded,
                                label: 'Tạo hợp\nđồng',
                                onTap: () =>
                                    context.push('/landlord/create-contract'),
                              ),
                              _QuickAction(
                                icon: Icons.domain_add_rounded,
                                label: 'Đăng\nphòng',
                                onTap: () => context.push('/landlord/add'),
                              ),
                              _QuickAction(
                                icon: Icons.campaign_rounded,
                                label: 'Đăng bảng\ntin',
                                onTap: () => context.push('/landlord/board'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Recent Activities
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Hoạt động gần đây',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Xem tất cả',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_right_alt_rounded,
                                      size: 16,
                                      color: colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _TimelineItem(
                              icon: Icons.payments_rounded,
                              iconColor: colorScheme.primary,
                              title: 'P.201 - Anh Minh đã thanh toán 3.8M',
                              time: '30 phút trước',
                              isFirst: true,
                            ),
                            _TimelineItem(
                              icon: Icons.receipt_long_rounded,
                              iconColor: Colors.blue,
                              title: 'Hóa đơn T3 đã gửi tới 26 phòng',
                              time: '2 giờ trước',
                            ),
                            _TimelineItem(
                              icon: Icons.build_rounded,
                              iconColor: Colors.red,
                              title: 'P.102 - Sự cố mới: Điều hòa không mát',
                              time: '3 giờ trước',
                            ),
                            _TimelineItem(
                              icon: Icons.assignment_rounded,
                              iconColor: Colors.brown,
                              title: 'P.301 - HĐ hết hạn ngày 01/04',
                              time: 'Hôm qua',
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeletePropertyDialog(
    BuildContext context,
    String propertyId,
    String propertyName,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận xóa?'),
        content: Text(
          'Bạn có chắc chắn muốn xóa khu trọ "$propertyName"? Dữ liệu sẽ bị xóa vĩnh viễn và không thể khôi phục.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<PropertyCubit>().deleteProperty(propertyId);
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _AreaChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _AreaChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _StatCardSkeleton extends StatefulWidget {
  const _StatCardSkeleton();

  @override
  State<_StatCardSkeleton> createState() => _StatCardSkeletonState();
}

class _StatCardSkeletonState extends State<_StatCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 60,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String mainValue;
  final Color mainValueColor;
  final Widget subValueWidget;

  const _StatCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.mainValue,
    required this.mainValueColor,
    required this.subValueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    mainValue,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainValueColor,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              subValueWidget,
            ],
          ),
        ],
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final String? actionText;
  final IconData? actionIcon;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _AlertBanner({
    required this.icon,
    required this.iconColor,
    required this.text,
    this.actionText,
    this.actionIcon,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: iconColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(11, 14, 16, 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 14),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (actionText != null)
                      Text(
                        actionText!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    if (actionIcon != null)
                      Icon(actionIcon, color: textColor, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: colorScheme.primary, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String time;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.time,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                if (!isFirst)
                  Container(width: 1, height: 16, color: Colors.grey.shade300)
                else
                  const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 10, color: iconColor),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1, color: Colors.grey.shade300),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
