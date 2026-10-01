import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class AppTile extends StatelessWidget {
  const AppTile({required this.title, this.subtitle, this.icon, this.trailing, this.onTap, super.key});

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 68),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              if (icon != null) ...[Icon(icon, size: 22, color: colors.accent), const SizedBox(width: 16)],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: colors.ink),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: colors.ink2),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 12), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
