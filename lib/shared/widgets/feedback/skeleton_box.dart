import 'package:flutter/material.dart';

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({required this.height, this.radius = 18, this.width, super.key});

  final double height;
  final double radius;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius)),
    );
  }
}
