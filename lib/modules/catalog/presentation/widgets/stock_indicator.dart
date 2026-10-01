import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class StockIndicator extends StatelessWidget {
  const StockIndicator({required this.stock, super.key});

  final int stock;

  static String labelFor(Translations t, int stock) => stock == 0 ? t.stock.out : t.stock.units(n: stock);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;

    final label = labelFor(t, stock);
    final dotColor = switch (stock) {
      0 => colors.bad,
      <= 5 => colors.warn,
      _ => colors.ok,
    };

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
