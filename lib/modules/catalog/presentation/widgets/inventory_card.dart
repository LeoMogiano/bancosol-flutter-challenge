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
    final colors = context.colors;
    final timeStr = syncedAt != null ? DateFormat.Hm().format(syncedAt!) : '';

    final valueSize = 22.65.sp;
    return Container(
      decoration: BoxDecoration(color: colors.accent, borderRadius: BorderRadius.circular(_radius)),
      padding: const EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  context.t.summary.inventoryValue,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.onAccent.withValues(alpha: 0.85),
                  ),
                ),
              ),
              if (syncedAt != null)
                Text(
                  context.t.summary.syncedAt(time: timeStr),
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.onAccent.withValues(alpha: 0.75),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          // FittedBox: un inventario de 7 cifras no entra en 320 dp con el tamaño del diseño.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
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
                const SizedBox(width: 6),
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
          const SizedBox(height: 4),
          Text(
            context.t.summary.formula,
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
