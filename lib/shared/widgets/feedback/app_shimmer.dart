import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class AppShimmer extends StatelessWidget {
  const AppShimmer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final base = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08);
    final highlight = isDark ? Colors.white.withValues(alpha: 0.22) : Colors.black.withValues(alpha: 0.18);

    return RepaintBoundary(
      child: Shimmer.fromColors(baseColor: base, highlightColor: highlight, child: child),
    );
  }
}
