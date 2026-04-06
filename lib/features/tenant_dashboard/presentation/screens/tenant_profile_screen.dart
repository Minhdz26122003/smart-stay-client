import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class TenantProfileScreen extends StatelessWidget {
  const TenantProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        state.maybeWhen(
          unauthenticated: () => ctx.go('/welcome'),
          orElse: () {},
        );
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (ctx, state) {
          final user = state.maybeWhen(
            authenticated: (u) => u,
            orElse: () => null,
          );
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FF),
            body: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    color: cs.primary,
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.2),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          user?.fullName ?? 'Nguyễn Thị Linh',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'linh.nguyen@email.com',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Badges
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _Badge(
                              '✅ Đã xác thực',
                              Colors.white.withValues(alpha: 0.2),
                            ),
                            const SizedBox(width: 8),
                            _Badge(
                              '🛏️ Người thuê',
                              Colors.white.withValues(alpha: 0.2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Stats row
                        Row(
                          children: [
                            Expanded(
                              child: _StatsCard(
                                icon: Icons.receipt_long_rounded,
                                label: 'Hóa đơn',
                                value: '4',
                                color: cs.primary,
                                cs: cs,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatsCard(
                                icon: Icons.warning_amber_rounded,
                                label: 'Sự cố',
                                value: '2',
                                color: Colors.orange,
                                cs: cs,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatsCard(
                                icon: Icons.description_rounded,
                                label: 'HĐ còn',
                                value: '8T',
                                color: Colors.green,
                                cs: cs,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Current room card
                        GestureDetector(
                          onTap: () => context.push('/tenant/my-room'),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: cs.primaryContainer.withValues(
                                      alpha: 0.3,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.apartment_rounded,
                                    color: cs.primary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Phòng 205 - Tầng 2 · Khu A',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '45 Lê Lợi, Q.1 · Nguyễn Văn Hùng',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: cs.onSurface.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: cs.onSurface.withValues(alpha: 0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Settings sections
                        _SettingsSection(
                          title: 'Tài khoản',
                          items: [
                            _SettingsItem(
                              icon: Icons.person_outline_rounded,
                              label: 'Thông tin cá nhân',
                              cs: cs,
                              onTap: () {},
                            ),
                            _SettingsItem(
                              icon: Icons.lock_outline_rounded,
                              label: 'Đổi mật khẩu',
                              cs: cs,
                              onTap: () {},
                            ),
                            _SettingsItem(
                              icon: Icons.notifications_outlined,
                              label: 'Cài đặt thông báo',
                              cs: cs,
                              onTap: () {},
                            ),
                          ],
                          cs: cs,
                          theme: theme,
                        ),
                        const SizedBox(height: 12),
                        _SettingsSection(
                          title: 'Phòng & Hợp đồng',
                          items: [
                            _SettingsItem(
                              icon: Icons.description_rounded,
                              label: 'Xem hợp đồng',
                              cs: cs,
                              onTap: () => context.push('/tenant/contract'),
                            ),
                            _SettingsItem(
                              icon: Icons.people_outline_rounded,
                              label: 'Khai báo khách',
                              cs: cs,
                              onTap: () {},
                            ),
                            _SettingsItem(
                              icon: Icons.exit_to_app_rounded,
                              label: 'Thủ tục trả phòng',
                              cs: cs,
                              trailing: const Text(
                                '⚠️',
                                style: TextStyle(fontSize: 14),
                              ),
                              onTap: () {},
                            ),
                          ],
                          cs: cs,
                          theme: theme,
                        ),
                        const SizedBox(height: 12),
                        _SettingsSection(
                          title: 'Hỗ trợ',
                          items: [
                            _SettingsItem(
                              icon: Icons.help_outline_rounded,
                              label: 'Trung tâm hỗ trợ',
                              cs: cs,
                              onTap: () {},
                            ),
                            _SettingsItem(
                              icon: Icons.feedback_outlined,
                              label: 'Gửi phản hồi',
                              cs: cs,
                              onTap: () {},
                            ),
                            _SettingsItem(
                              icon: Icons.info_outline_rounded,
                              label: 'Về Smart Stay',
                              cs: cs,
                              onTap: () {},
                            ),
                          ],
                          cs: cs,
                          theme: theme,
                        ),
                        const SizedBox(height: 20),

                        // Logout button
                        ElevatedButton.icon(
                          onPressed: () => context.read<AuthBloc>().add(
                            const AuthEvent.logoutRequested(),
                          ),
                          icon: const Icon(
                            Icons.logout_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Đăng xuất',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.error,
                            minimumSize: const Size(double.infinity, 50),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _StatsCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  final ColorScheme cs;
  const _StatsCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: cs.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ],
    ),
  );
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;
  final ColorScheme cs;
  final ThemeData theme;

  const _SettingsSection({
    required this.title,
    required this.items,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: cs.onSurface.withValues(alpha: 0.4),
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...items.asMap().entries.map(
          (e) => Column(
            children: [
              e.value,
              if (e.key < items.length - 1)
                Divider(
                  height: 1,
                  indent: 56,
                  color: cs.outlineVariant.withValues(alpha: 0.5),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ColorScheme cs;
  final Widget? trailing;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.cs,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: cs.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          if (trailing != null) ...[trailing!, const SizedBox(width: 6)],
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: cs.onSurface.withValues(alpha: 0.3),
          ),
        ],
      ),
    ),
  );
}
