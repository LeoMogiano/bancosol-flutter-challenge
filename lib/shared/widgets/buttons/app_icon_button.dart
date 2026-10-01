import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    this.color,
    this.tooltip,
    this.badge = 0,
    this.size = 44,
    super.key,
  });

  static const double _iconSize = 21;
  static const double _badgeSize = 18;

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final String? tooltip;
  final int badge;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null;
    Widget button = Material(
      color: colors.surface,
      shape: CircleBorder(side: BorderSide(color: colors.line)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox.square(
          dimension: size,
          child: Icon(
            icon,
            size: _iconSize,
            color: (color ?? colors.ink).withValues(alpha: enabled ? 1 : 0.45),
          ),
        ),
      ),
    );
    if (badge > 0) {
      button = Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              constraints: const BoxConstraints(minWidth: _badgeSize, minHeight: _badgeSize),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.accent,
                shape: BoxShape.circle,
                border: Border.all(color: colors.surface, width: 2),
              ),
              child: Text(
                '$badge',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: colors.onAccent),
              ),
            ),
          ),
        ],
      );
    }
    final label = tooltip;
    return label == null ? button : Tooltip(message: label, child: button);
  }
}
