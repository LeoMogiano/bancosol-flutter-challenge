import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/shared/formatters/price_formatter.dart';
import 'package:warehouse/shared/widgets/cards/app_card.dart';

class DetailPriceCard extends StatelessWidget {
  const DetailPriceCard({required this.price, required this.currency, required this.edited, super.key});

  final double price;
  final String currency;
  final ValueListenable<bool> edited;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  t.detail.price,
                  style: TextStyle(fontSize: 14.sp, color: colors.ink2),
                ),
              ),
              _EditedBadge(edited: edited),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            spacing: 6,
            children: [
              Flexible(
                child: Text(
                  PriceFormatter.format(price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w700, color: colors.accent, height: 1.1),
                ),
              ),
              Text(
                currency,
                style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600, color: colors.ink2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditedBadge extends StatelessWidget {
  const _EditedBadge({required this.edited});

  final ValueListenable<bool> edited;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;

    return ValueListenableBuilder(
      valueListenable: edited,
      builder: (_, isEdited, _) {
        if (!isEdited) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: colors.accentSoft, borderRadius: BorderRadius.circular(10)),
          child: Text(
            t.detail.updated,
            style: TextStyle(fontSize: 12.5.sp, color: colors.accent, fontWeight: FontWeight.w500),
          ),
        );
      },
    );
  }
}
