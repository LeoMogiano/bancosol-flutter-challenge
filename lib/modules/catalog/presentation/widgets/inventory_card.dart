import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/shared/formatters/price_formatter.dart';

class InventoryCard extends StatelessWidget {
  const InventoryCard({required this.totalBob, required this.syncedAt, super.key});

  static const double _radius = 24;
  static const double _padding = 20;

  final double totalBob;
  final DateTime? syncedAt;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final timeStr = syncedAt != null ? DateFormat.Hm().format(syncedAt!) : '';

    final valueSize = 22.65.sp;
    return Container(
      decoration: BoxDecoration(color: colors.accent, borderRadius: BorderRadius.circular(_radius)),
      padding: const EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  t.summary.inventoryValue,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.onAccent.withValues(alpha: 0.85),
                  ),
                ),
              ),
              if (syncedAt != null)
                Text(
                  t.summary.syncedAt(time: timeStr),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.onAccent.withValues(alpha: 0.75),
                  ),
                ),
            ],
          ),
          // FittedBox: un inventario de 7 cifras no entra en 320 dp con el tamaño del diseño.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              spacing: 6,
              children: [
                Text(
                  PriceFormatter.format(totalBob),
                  style: TextStyle(
                    fontSize: valueSize,
                    fontWeight: FontWeight.w700,
                    color: colors.onAccent,
                    letterSpacing: -0.02 * valueSize,
                  ),
                ),
                Text(
                  'BOB',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.onAccent.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Text(
            t.summary.formula,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colors.onAccent.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
