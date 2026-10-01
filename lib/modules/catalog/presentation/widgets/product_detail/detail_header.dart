import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/app_fonts.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_avatar.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      spacing: 16,
      children: [
        ProductAvatar(product: product, size: 76),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFont.playfairDisplay.family,
                  color: colors.ink,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: colors.surface2, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  product.sku,
                  style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: colors.ink2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
