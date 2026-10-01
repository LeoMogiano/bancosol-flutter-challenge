import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w600, color: context.colors.ink),
        ),
        child,
      ],
    );
  }
}
