import 'package:flutter/material.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class SkeletonBox extends StatefulWidget {
  const SkeletonBox({required this.height, this.radius = 18, this.width, super.key});

  final double height;
  final double radius;
  final double? width;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox> with SingleTickerProviderStateMixin {
  static const _period = Duration(milliseconds: 1300);

  late final AnimationController _controller = AnimationController(vsync: this, duration: _period)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) {
          final shift = _controller.value * 2 - 1;
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              gradient: LinearGradient(
                begin: Alignment(shift - 1, 0),
                end: Alignment(shift + 1, 0),
                colors: [colors.surface2, colors.surface, colors.surface2],
              ),
            ),
          );
        },
      ),
    );
  }
}
