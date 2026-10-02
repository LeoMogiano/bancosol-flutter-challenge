import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/generated/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/stock_indicator.dart';
import 'package:warehouse/shared/widgets/cards/app_card.dart';

class DetailInfoTable extends StatelessWidget {
  const DetailInfoTable({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final divider = Divider(height: 1, color: context.colors.line);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _InfoRow(label: t.detail.sku, value: product.sku),
          divider,
          _InfoRow(
            label: t.detail.stock,
            value: '',
            trailing: StockIndicator(stock: product.stock),
          ),
          divider,
          _InfoRow(label: t.detail.currency, value: product.currency.code),
          divider,
          _InfoRow(label: t.detail.id, value: '${product.id}', valueWeight: FontWeight.w400),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.trailing, this.valueWeight = FontWeight.w600});

  final String label;
  final String value;
  final Widget? trailing;
  final FontWeight valueWeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontSize: 14.5.sp, color: colors.ink2),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 14.5.sp, fontWeight: valueWeight, color: colors.ink),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}
