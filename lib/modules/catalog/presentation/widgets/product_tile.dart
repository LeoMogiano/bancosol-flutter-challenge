import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_avatar.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/stock_indicator.dart';
import 'package:warehouse/shared/formatters/price_formatter.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({required this.product, required this.onTap, this.highlighted = false, super.key});

  static const double _minHeight = 68;
  static const double _radius = 18;
  static const double _padding = 12;
  static const int _animationDurationMs = 300;

  final Product product;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderColor = highlighted ? colors.accent : colors.line;
    final borderWidth = highlighted ? 2.0 : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: _animationDurationMs),
        constraints: const BoxConstraints(minHeight: _minHeight),
        padding: const EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Row(
          spacing: 12,
          children: [
            ProductAvatar(product: product),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: colors.ink),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Flexible(
                        child: Text(
                          product.sku,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: colors.ink3),
                        ),
                      ),
                      StockIndicator(stock: product.stock),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 3,
              children: [
                Text(
                  PriceFormatter.format(product.price),
                  style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w700, color: colors.ink),
                ),
                Text(
                  product.currency,
                  style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w400, color: colors.ink3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
