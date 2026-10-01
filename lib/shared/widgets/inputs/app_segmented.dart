import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class AppSegment<T> {
  const AppSegment({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

class AppSegmented<T> extends StatelessWidget {
  const AppSegmented({required this.segments, required this.selected, required this.onChanged, super.key});

  final List<AppSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  static const double _height = 44;
  static const double _padding = 4;
  static const double _segmentRadius = 14;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: _height,
      padding: const EdgeInsets.all(_padding),
      decoration: BoxDecoration(color: colors.bg, borderRadius: BorderRadius.circular(_segmentRadius)),
      child: Row(
        children: List.generate(segments.length, (index) {
          final segment = segments[index];
          final isSelected = segment.value == selected;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(segment.value),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? colors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (segment.icon != null) ...[
                      Icon(segment.icon, size: 18, color: isSelected ? colors.ink : colors.ink2),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      segment.label,
                      style: TextStyle(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? colors.ink : colors.ink2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
