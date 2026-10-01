import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';

class ResultsLine extends StatelessWidget {
  const ResultsLine({required this.onClearFilters, super.key});

  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final data = context.select<ProductsBloc, ({int count, bool filtered})>(
      (bloc) => (count: bloc.state.visible.length, filtered: bloc.state.filters.activeCount > 0),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 12, 4),
      child: SizedBox(
        height: 36,
        child: Row(
          children: [
            Expanded(
              child: Text(
                t.products.results(n: data.count),
                style: TextStyle(fontSize: 14.sp, color: colors.ink2),
              ),
            ),
            if (data.filtered)
              TextButton(
                onPressed: onClearFilters,
                child: Text(
                  t.products.clearFilters,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: colors.accent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
