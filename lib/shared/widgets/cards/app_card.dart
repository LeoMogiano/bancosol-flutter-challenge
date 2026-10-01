import 'package:flutter/material.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class AppCard extends StatelessWidget {
  const AppCard({required this.child, this.padding = const EdgeInsets.all(16), this.color, this.onTap, super.key});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final backgroundColor = color ?? colors.surface;
    final isDisabled = onTap == null;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.line),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
