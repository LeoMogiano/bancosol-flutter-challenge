import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/constants/app_routes.dart';
import 'package:warehouse/core/i18n/generated/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_tile.dart';
import 'package:warehouse/shared/widgets/navigation/app_paginator.dart';

class ProductList extends StatelessWidget {
  const ProductList({required this.onPageChanged, super.key});

  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final data = context.select<ProductsBloc, ({List<Product> items, String? highlightId, bool offline})>(
      (bloc) => (items: bloc.state.pageItems, highlightId: bloc.state.highlightId, offline: bloc.state.isOffline),
    );

    return Padding(
      // Holgura para que la barra de navegación flotante (y el aviso offline) no tapen el último elemento.
      padding: EdgeInsets.fromLTRB(20, 4, 20, data.offline ? 190 : 130),
      child: Column(
        spacing: 8,
        children: [
          for (final product in data.items)
            ProductTile(
              key: ValueKey(product.remoteId),
              product: product,
              highlighted: product.remoteId == data.highlightId,
              onTap: () => context.push(AppRoutes.productDetail(product.remoteId)),
            ),
          _PaginationFooter(onPageChanged: onPageChanged),
        ],
      ),
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({required this.onPageChanged});

  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final data = context.select<ProductsBloc, ({int page, int pageCount, int total})>(
      (bloc) => (page: bloc.state.page, pageCount: bloc.state.pageCount, total: bloc.state.visible.length),
    );
    final from = (data.page - 1) * ProductQuery.pageSize + 1;
    final to = math.min(data.page * ProductQuery.pageSize, data.total);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        spacing: 12,
        children: [
          Text(
            t.products.showing(from: '$from', to: '$to', total: '${data.total}'),
            style: TextStyle(fontSize: 14.sp, color: context.colors.ink3),
          ),
          AppPaginator(
            page: data.page,
            pageCount: data.pageCount,
            onChanged: onPageChanged,
            pageLabel: (n) => t.a11y.page(n: n),
          ),
        ],
      ),
    );
  }
}
