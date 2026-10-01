import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/modules/catalog/application/filters/filter_draft_bloc.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/filter_sheet/filter_section.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/filter_sheet/price_range_section.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/filter_sheet/sort_section.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/feedback/custom_bottom_sheet.dart';
import 'package:warehouse/shared/widgets/inputs/app_segmented.dart';
import 'package:warehouse/shared/widgets/lists/app_switch_tile.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({required this.sort, required this.filters, required this.all, required this.query, super.key});

  final ProductSort sort;
  final ProductFilters filters;
  final List<Product> all;
  final String query;

  static Future<({ProductSort sort, ProductFilters filters})?> open(
    BuildContext context, {
    required ProductsState state,
  }) {
    return CustomBottomSheet.show<({ProductSort sort, ProductFilters filters})>(
      context,
      FilterSheet(sort: state.sort, filters: state.filters, all: state.all, query: state.query),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterDraftBloc(sort: sort, filters: filters, all: all, query: query),
      child: const _FilterSheetContent(),
    );
  }
}

class _FilterSheetContent extends StatelessWidget {
  const _FilterSheetContent();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18,
      children: [
        SheetHeader(title: t.filters.title),
        const SortSection(),
        const PriceRangeSection(),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [_CurrencySection(), _InStockSection()],
        ),
        const _ActionsSection(),
      ],
    );
  }
}

class _CurrencySection extends StatelessWidget {
  const _CurrencySection();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final bloc = context.read<FilterDraftBloc>();

    final selectedCurrency = context.select<FilterDraftBloc, String?>((bloc) => bloc.state.currency);
    final segments = [
      AppSegment(value: null, label: t.filters.all),
      const AppSegment(value: 'BOB', label: 'BOB'),
      const AppSegment(value: 'USD', label: 'USD'),
    ];

    return FilterSection(
      title: t.filters.currency,
      child: AppSegmented<String?>(
        segments: segments,
        selected: selectedCurrency,
        onChanged: (currency) => bloc.add(FilterDraftCurrencyChanged(currency)),
      ),
    );
  }
}

class _InStockSection extends StatelessWidget {
  const _InStockSection();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final bloc = context.read<FilterDraftBloc>();

    final inStockOnly = context.select<FilterDraftBloc, bool>((bloc) => bloc.state.inStockOnly);
    return AppSwitchTile(
      title: t.filters.inStockOnly,
      subtitle: t.filters.inStockOnlyHint,
      value: inStockOnly,
      onChanged: (value) => bloc.add(FilterDraftInStockToggled(inStockOnly: value)),
    );
  }
}

class _ActionsSection extends StatelessWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final bloc = context.read<FilterDraftBloc>();

    final data = context.select<FilterDraftBloc, ({bool rangeValid, int resultCount})>(
      (bloc) => (rangeValid: bloc.rangeValid, resultCount: bloc.resultCount),
    );
    return SheetActions(
      secondary: AppButton(
        label: t.filters.reset,
        onPressed: () => bloc.add(const FilterDraftReset()),
        variant: AppButtonVariant.outline,
      ),
      primary: AppButton(
        label: t.filters.apply(n: data.resultCount),
        onPressed: data.rangeValid
            ? () => Navigator.of(context).pop((sort: bloc.state.sort, filters: bloc.filters))
            : null,
      ),
    );
  }
}
