import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({required this.message, this.title, super.key});

  final String message;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(color: colors.badSoft, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_rounded, size: 20, color: colors.bad),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w600, color: colors.ink),
                  ),
                if (title != null) const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: colors.ink2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
