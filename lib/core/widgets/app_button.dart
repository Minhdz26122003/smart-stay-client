import 'package:flutter/material.dart';

/// Primary CTA Button — Harmonious Host Design System
/// Spec: pill shape (radius 24px), min-height 56px, gradient primary→primary_container
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final AppButtonVariant variant;
  final Widget? leadingIcon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 46,
      child: switch (variant) {
        AppButtonVariant.primary => _PrimaryButton(
            label: label,
            onPressed: isLoading ? null : onPressed,
            isLoading: isLoading,
            leadingIcon: leadingIcon,
            colorScheme: colorScheme,
          ),
        AppButtonVariant.secondary => _SecondaryButton(
            label: label,
            onPressed: isLoading ? null : onPressed,
            isLoading: isLoading,
            colorScheme: colorScheme,
          ),
        AppButtonVariant.ghost => _GhostButton(
            label: label,
            onPressed: isLoading ? null : onPressed,
            colorScheme: colorScheme,
          ),
      },
    );
  }
}

enum AppButtonVariant { primary, secondary, ghost }

// ─── Primary: gradient pill ───────────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? leadingIcon;
  final ColorScheme colorScheme;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    required this.colorScheme,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: onPressed == null
            ? null
            : LinearGradient(
                colors: [colorScheme.primary, colorScheme.primaryContainer],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        color: onPressed == null ? colorScheme.onSurface.withOpacity(0.12) : null,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: colorScheme.onPrimary,
          disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    leadingIcon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─── Secondary: secondary_container background ────────────────────────────────
class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ColorScheme colorScheme;

  const _SecondaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        elevation: 0,
      ),
      child: isLoading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colorScheme.onSecondaryContainer,
              ),
            )
          : Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
    );
  }
}

// ─── Ghost: transparent, primary text ─────────────────────────────────────────
class _GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ColorScheme colorScheme;

  const _GhostButton({
    required this.label,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}
