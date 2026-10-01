import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class StockIndicator extends StatelessWidget {
  const StockIndicator({required this.stock, super.key});

  final int stock;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;

    late final Color dotColor;
    late final String label;

    if (stock == 0) {
      dotColor = colors.bad;
      label = t.stock.out;
    } else if (stock >= 1 && stock <= 5) {
      dotColor = colors.warn;
      label = t.stock.units(n: stock);
    } else {
      dotColor = colors.ok;
      label = t.stock.units(n: stock);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: dotColor),
        ),
      ],
    );
  }
}
