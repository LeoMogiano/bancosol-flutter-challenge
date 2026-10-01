import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/services/haptic_service.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class AppSegment<T> {
  const AppSegment({required this.value, required this.label, this.icon, this.leading});

  final T value;
  final String label;
  final IconData? icon;

  // Para lo que no es un ícono (banderas, avatares); si se pasa, reemplaza a `icon`.
  final Widget? leading;
}

class AppSegmented<T> extends StatelessWidget {
  const AppSegmented({required this.segments, required this.selected, required this.onChanged, super.key});

  final List<AppSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  static const double _padding = 6;
  static const double _gap = 6;
  static const double _minSegmentHeight = 44;
  static const double _radius = 20;
  static const double _segmentRadius = 14;

  void _select(T value) {
    if (value == selected) return;
    HapticService.selection();
    onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        children: List.generate(segments.length, (index) {
          final segment = segments[index];
          final isSelected = segment.value == selected;
          final foreground = isSelected ? colors.onAccent : colors.ink;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : _gap),
              child: GestureDetector(
                onTap: () => _select(segment.value),
                child: Container(
                  constraints: const BoxConstraints(minHeight: _minSegmentHeight),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.accent : colors.bg,
                    borderRadius: BorderRadius.circular(_segmentRadius),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (segment.leading != null) ...[
                          segment.leading!,
                          const SizedBox(width: 6),
                        ] else if (segment.icon != null) ...[
                          Icon(segment.icon, size: 18, color: foreground),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          segment.label,
                          maxLines: 1,
                          style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w500, color: foreground),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
