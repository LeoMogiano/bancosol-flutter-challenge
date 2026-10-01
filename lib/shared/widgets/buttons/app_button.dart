import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';

enum AppButtonVariant { primary, outline, danger, soft }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.loadingLabel,
    this.compact = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool loading;
  final String? loadingLabel;
  final bool compact;

  static const double _height = 54;
  static const double _compactHeight = 46;
  static const double _borderRadius = 27;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final height = compact ? _compactHeight : _height;
    final effectiveOnPressed = loading ? null : onPressed;
    final isDisabled = effectiveOnPressed == null;

    Color backgroundColor;
    Color textColor;
    BorderSide? borderSide;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = colors.accent;
        textColor = colors.onAccent;
      case AppButtonVariant.outline:
        backgroundColor = Colors.transparent;
        textColor = colors.ink;
        borderSide = BorderSide(color: colors.ink, width: 1.5);
      case AppButtonVariant.danger:
        backgroundColor = colors.bad;
        textColor = colors.onAccent;
      case AppButtonVariant.soft:
        backgroundColor = colors.surface;
        textColor = colors.ink;
        borderSide = BorderSide(color: colors.line);
    }

    if (isDisabled && variant == AppButtonVariant.primary) {
      backgroundColor = backgroundColor.withValues(alpha: 0.45);
    } else if (isDisabled) {
      textColor = textColor.withValues(alpha: 0.45);
      backgroundColor = backgroundColor.withValues(alpha: backgroundColor.a * 0.45);
    }

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: FilledButton(
        onPressed: effectiveOnPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          side: borderSide,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading) ...[
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(textColor)),
              ),
              const SizedBox(width: 8),
            ] else if (icon != null) ...[
              Icon(icon, size: 20, color: textColor),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                loading ? (loadingLabel ?? label) : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
