import 'package:flutter/material.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/shared/widgets/lists/app_tile.dart';

class AppSwitchTile extends StatelessWidget {
  const AppSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    super.key,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppTile(
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: () => onChanged(!value),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        thumbColor: WidgetStatePropertyAll(colors.surface),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? colors.accent : colors.surface2,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
    );
  }
}
