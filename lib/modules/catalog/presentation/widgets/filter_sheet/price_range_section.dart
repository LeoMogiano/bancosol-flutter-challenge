import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/filters/filter_draft_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/currency.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/filter_sheet/filter_section.dart';
import 'package:warehouse/shared/widgets/inputs/price_field.dart';

class PriceRangeSection extends StatelessWidget {
  const PriceRangeSection({super.key});

  static const double _sideBySideMinWidth = 340;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isValid = context.select<FilterDraftBloc, bool>((bloc) => bloc.rangeValid);

    return FilterSection(
      title: t.filters.priceRange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En pantallas angostas lado a lado no deja espacio para escribir el monto.
          LayoutBuilder(
            builder: (_, constraints) => constraints.maxWidth < _sideBySideMinWidth
                ? const Column(spacing: 10, children: [_BoundField(isMin: true), _BoundField(isMin: false)])
                : const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Expanded(child: _BoundField(isMin: true)),
                      Expanded(child: _BoundField(isMin: false)),
                    ],
                  ),
          ),
          if (!isValid)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                t.filters.rangeError,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: context.colors.bad),
              ),
            ),
        ],
      ),
    );
  }
}

class _BoundField extends StatelessWidget {
  const _BoundField({required this.isMin});

  final bool isMin;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final bloc = context.read<FilterDraftBloc>();
    // El texto se selecciona para que `reset` limpie el campo; cada límite escucha solo el suyo.
    final data = context.select<FilterDraftBloc, ({String text, bool valid})>(
      (bloc) => (text: isMin ? bloc.state.minText : bloc.state.maxText, valid: bloc.rangeValid),
    );

    return PriceField(
      currency: Currency.bob.code,
      label: isMin ? t.filters.min : t.filters.max,
      initialValue: data.text,
      onChanged: (text) => bloc.add(isMin ? FilterDraftMinChanged(text) : FilterDraftMaxChanged(text)),
      errorText: data.valid ? null : '',
    );
  }
}
