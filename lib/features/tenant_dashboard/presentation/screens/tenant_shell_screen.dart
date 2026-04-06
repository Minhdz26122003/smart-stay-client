import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TenantShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const TenantShellScreen({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final selected = navigationShell.currentIndex;

    const items = [
      (Icons.home_rounded, Icons.home_outlined, 'Trang chủ'),
      (Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Hóa đơn'),
      (Icons.build_rounded, Icons.build_outlined, 'Dịch vụ'),
      (Icons.notifications_rounded, Icons.notifications_outlined, 'Thông báo'),
      (Icons.person_rounded, Icons.person_outlined, 'Tài khoản'),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
            child: Row(
              children: List.generate(items.length, (i) {
                final isSelected = selected == i;
                final item = items[i];
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _goBranch(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: isSelected ? 16 : 0,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? cs.primary.withValues(alpha: 0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            isSelected ? item.$1 : item.$2,
                            size: 22,
                            color: isSelected
                                ? cs.primary
                                : cs.onSurface.withValues(alpha: 0.45),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.$3,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.normal,
                            color: isSelected
                                ? cs.primary
                                : cs.onSurface.withValues(alpha: 0.45),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
