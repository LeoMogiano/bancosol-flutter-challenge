import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/filters/filter_draft_cubit.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/feedback/custom_bottom_sheet.dart';
import 'package:warehouse/shared/widgets/inputs/app_segmented.dart';
import 'package:warehouse/shared/widgets/inputs/price_field.dart';
import 'package:warehouse/shared/widgets/lists/app_switch_tile.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({required this.sort, required this.filters, required this.all, required this.query, super.key});

  static const double _gap = 10;

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
      create: (context) => FilterDraftCubit(sort: sort, filters: filters, all: all, query: query),
      child: const _FilterSheetContent(),
    );
  }
}

class _FilterSheetContent extends StatelessWidget {
  const _FilterSheetContent();

  static const double _gridGap = 8;
  static const double _chipHeight = 44;
  static const double _chipRadius = 14;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SheetHeader(title: context.t.filters.title),
        const SizedBox(height: 18),
        const _SortSection(),
        const SizedBox(height: 18),
        const _PriceRangeSection(),
        const SizedBox(height: 18),
        const _CurrencySection(),
        const SizedBox(height: 10),
        const _InStockSection(),
        const SizedBox(height: 18),
        const _ActionsSection(),
      ],
    );
  }
}

class _SortSection extends StatelessWidget {
  const _SortSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FilterDraftCubit>();
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.filters.sortBy,
          style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w600, color: colors.ink),
        ),
        const SizedBox(height: FilterSheet._gap),
        BlocSelector<FilterDraftCubit, FilterDraftState, ProductSort>(
          selector: (state) => state.sort,
          builder: (context, selectedSort) {
            return GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: _FilterSheetContent._gridGap,
                mainAxisSpacing: _FilterSheetContent._gridGap,
                mainAxisExtent: _FilterSheetContent._chipHeight,
              ),
              children: [
                _SortChip(
                  label: context.t.filters.priceDesc,
                  icon: Icons.arrow_downward_rounded,
                  isSelected: selectedSort == ProductSort.priceDesc,
                  onTap: () => cubit.sortChanged(ProductSort.priceDesc),
                ),
                _SortChip(
                  label: context.t.filters.priceAsc,
                  icon: Icons.arrow_upward_rounded,
                  isSelected: selectedSort == ProductSort.priceAsc,
                  onTap: () => cubit.sortChanged(ProductSort.priceAsc),
                ),
                _SortChip(
                  label: context.t.filters.nameAsc,
                  icon: Icons.sort_by_alpha_rounded,
                  isSelected: selectedSort == ProductSort.nameAsc,
                  onTap: () => cubit.sortChanged(ProductSort.nameAsc),
                ),
                _SortChip(
                  label: context.t.filters.sku,
                  icon: Icons.tag_rounded,
                  isSelected: selectedSort == ProductSort.sku,
                  onTap: () => cubit.sortChanged(ProductSort.sku),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({required this.label, required this.icon, required this.isSelected, required this.onTap});

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isSelected ? colors.accent : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_FilterSheetContent._chipRadius),
        side: isSelected ? BorderSide.none : BorderSide(color: colors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: isSelected ? colors.onAccent : colors.ink),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? colors.onAccent : colors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceRangeSection extends StatelessWidget {
  const _PriceRangeSection();

  static const double _sideBySideMinWidth = 340;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FilterDraftCubit>();
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.filters.priceRange,
          style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w600, color: colors.ink),
        ),
        const SizedBox(height: FilterSheet._gap),
        BlocSelector<FilterDraftCubit, FilterDraftState, (String, String)>(
          selector: (state) => (state.minText, state.maxText),
          builder: (context, _) {
            final cubitState = context.read<FilterDraftCubit>().state;
            final isValid = context.read<FilterDraftCubit>().rangeValid;

            final min = PriceField(
              currency: 'BOB',
              label: context.t.filters.min,
              initialValue: cubitState.minText,
              onChanged: cubit.minChanged,
              errorText: isValid ? null : '',
            );
            final max = PriceField(
              currency: 'BOB',
              label: context.t.filters.max,
              initialValue: cubitState.maxText,
              onChanged: cubit.maxChanged,
              errorText: isValid ? null : '',
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En pantallas angostas lado a lado no deja espacio para escribir el monto.
                LayoutBuilder(
                  builder: (_, constraints) => constraints.maxWidth < _sideBySideMinWidth
                      ? Column(children: [min, const SizedBox(height: 10), max])
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: min),
                            const SizedBox(width: 10),
                            Expanded(child: max),
                          ],
                        ),
                ),
                if (!isValid)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      context.t.filters.rangeError,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: colors.bad),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CurrencySection extends StatelessWidget {
  const _CurrencySection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FilterDraftCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.filters.currency,
          style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w600, color: context.colors.ink),
        ),
        const SizedBox(height: FilterSheet._gap),
        BlocSelector<FilterDraftCubit, FilterDraftState, String?>(
          selector: (state) => state.currency,
          builder: (context, selectedCurrency) {
            final segments = [
              AppSegment(value: null, label: context.t.filters.all),
              const AppSegment(value: 'BOB', label: 'BOB'),
              const AppSegment(value: 'USD', label: 'USD'),
            ];

            return AppSegmented<String?>(
              segments: segments,
              selected: selectedCurrency,
              onChanged: cubit.currencyChanged,
            );
          },
        ),
      ],
    );
  }
}

class _InStockSection extends StatelessWidget {
  const _InStockSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FilterDraftCubit>();

    return BlocSelector<FilterDraftCubit, FilterDraftState, bool>(
      selector: (state) => state.inStockOnly,
      builder: (context, inStockOnly) {
        return AppSwitchTile(
          title: context.t.filters.inStockOnly,
          subtitle: context.t.filters.inStockOnlyHint,
          value: inStockOnly,
          onChanged: cubit.inStockChanged,
        );
      },
    );
  }
}

class _ActionsSection extends StatelessWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FilterDraftCubit>();

    return BlocBuilder<FilterDraftCubit, FilterDraftState>(
      builder: (context, state) {
        final isRangeValid = cubit.rangeValid;
        final resultCount = cubit.resultCount;

        return SheetActions(
          secondary: AppButton(
            label: context.t.filters.reset,
            onPressed: cubit.reset,
            variant: AppButtonVariant.outline,
          ),
          primary: AppButton(
            label: context.t.filters.apply(n: resultCount),
            onPressed: isRangeValid
                ? () => Navigator.of(context).pop((sort: state.sort, filters: cubit.filters))
                : null,
          ),
        );
      },
    );
  }
}
