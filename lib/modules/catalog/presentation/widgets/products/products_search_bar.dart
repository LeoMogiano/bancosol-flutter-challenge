import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/i18n/generated/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/shared/widgets/buttons/app_icon_button.dart';
import 'package:warehouse/shared/widgets/inputs/search_field.dart';

class ProductsSearchBar extends StatelessWidget {
  const ProductsSearchBar({required this.controller, required this.focusNode, required this.onOpenFilters, super.key});

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onOpenFilters;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: SearchField(
        controller: controller,
        focusNode: focusNode,
        hintText: t.products.searchHint,
        onChanged: (query) => context.read<ProductsBloc>().add(ProductsQueryChanged(query)),
        trailing: _FiltersButton(onPressed: onOpenFilters),
      ),
    );
  }
}

class _FiltersButton extends StatelessWidget {
  const _FiltersButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final activeCount = context.select<ProductsBloc, int>((bloc) => bloc.state.filters.activeCount);

    return AppIconButton(
      icon: Icons.tune_rounded,
      background: context.colors.surface2,
      size: 40,
      badge: activeCount,
      tooltip: t.filters.title,
      onPressed: onPressed,
    );
  }
}
