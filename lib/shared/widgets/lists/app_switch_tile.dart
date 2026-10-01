import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class AppSwitchTile extends StatelessWidget {
  const AppSwitchTile({required this.title, required this.value, required this.onChanged, this.subtitle, super.key});

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Column(
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
        Switch.adaptive(value: value, onChanged: onChanged, activeThumbColor: colors.accent),
      ],
    );
  }
}
