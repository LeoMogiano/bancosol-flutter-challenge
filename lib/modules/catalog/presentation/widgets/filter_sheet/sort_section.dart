import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/generated/strings.g.dart';
import 'package:warehouse/core/services/haptic_service.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/filters/filter_draft_bloc.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/filter_sheet/filter_section.dart';

class SortSection extends StatelessWidget {
  const SortSection({super.key});

  static const int _columns = 2;
  static const double _gridGap = 8;
  static const double _chipHeight = 44;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final bloc = context.read<FilterDraftBloc>();
    final selected = context.select<FilterDraftBloc, ProductSort>((bloc) => bloc.state.sort);
    final options = [
      (sort: ProductSort.priceDesc, label: t.filters.priceDesc, icon: Icons.arrow_downward_rounded),
      (sort: ProductSort.priceAsc, label: t.filters.priceAsc, icon: Icons.arrow_upward_rounded),
      (sort: ProductSort.nameAsc, label: t.filters.nameAsc, icon: Icons.sort_by_alpha_rounded),
      (sort: ProductSort.sku, label: t.filters.sku, icon: Icons.tag_rounded),
    ];

    return FilterSection(
      title: t.filters.sortBy,
      child: Column(
        spacing: _gridGap,
        children: [
          for (var row = 0; row < options.length; row += _columns)
            SizedBox(
              height: _chipHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: _gridGap,
                children: [
                  for (final option in options.skip(row).take(_columns))
                    Expanded(
                      child: _SortChip(
                        label: option.label,
                        icon: option.icon,
                        isSelected: selected == option.sort,
                        onTap: () {
                          if (selected == option.sort) return;
                          HapticService.selection();
                          bloc.add(FilterDraftSortChanged(option.sort));
                        },
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({required this.label, required this.icon, required this.isSelected, required this.onTap});

  static const double _radius = 14;

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = isSelected ? colors.onAccent : colors.ink;

    return MergeSemantics(
      child: Semantics(
        button: true,
        selected: isSelected,
        child: Material(
          color: isSelected ? colors.accent : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
            side: isSelected ? BorderSide.none : BorderSide(color: colors.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 6,
                children: [
                  Icon(icon, size: 17, color: foreground),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: foreground),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
