import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/product_form/product_form_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/currency.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';
import 'package:warehouse/modules/catalog/domain/validators/product_form_validator.dart';
import 'package:warehouse/modules/catalog/presentation/i18n/validation_i18n.dart';
import 'package:warehouse/shared/formatters/name_input_formatter.dart';
import 'package:warehouse/shared/formatters/sku_input_formatter.dart';
import 'package:warehouse/shared/formatters/stock_input_formatter.dart';
import 'package:warehouse/shared/widgets/inputs/app_segmented.dart';
import 'package:warehouse/shared/widgets/inputs/custom_input.dart';
import 'package:warehouse/shared/widgets/inputs/price_field.dart';

class FormSkuField extends StatelessWidget {
  const FormSkuField({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final bloc = context.read<ProductFormBloc>();

    final data = context.select<ProductFormBloc, (String, SkuError?)>((bloc) => (bloc.state.sku, bloc.skuError));

    return CustomInput(
      label: t.form.sku,
      initialValue: data.$1,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [SkuInputFormatter()],
      onChanged: (value) => bloc.add(ProductFormFieldChanged(ProductField.sku, value)),
      onBlur: () => bloc.add(const ProductFormFieldBlurred(ProductField.sku)),
      errorText: data.$2?.message,
    );
  }
}

class FormNameField extends StatelessWidget {
  const FormNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final bloc = context.read<ProductFormBloc>();

    final data = context.select<ProductFormBloc, (String, NameError?)>((bloc) => (bloc.state.name, bloc.nameError));

    return CustomInput(
      label: t.form.name,
      initialValue: data.$1,
      inputFormatters: [NameInputFormatter()],
      onChanged: (value) => bloc.add(ProductFormFieldChanged(ProductField.name, value)),
      onBlur: () => bloc.add(const ProductFormFieldBlurred(ProductField.name)),
      errorText: data.$2?.message,
    );
  }
}

class FormPriceField extends StatelessWidget {
  const FormPriceField({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final bloc = context.read<ProductFormBloc>();

    final data = context.select<ProductFormBloc, (String, Currency, PriceError?)>(
      (bloc) => (bloc.state.price, bloc.state.currency, bloc.priceError),
    );

    return PriceField(
      label: t.form.price,
      currency: data.$2.code,
      initialValue: data.$1,
      onChanged: (value) => bloc.add(ProductFormFieldChanged(ProductField.price, value)),
      onBlur: () => bloc.add(const ProductFormFieldBlurred(ProductField.price)),
      errorText: data.$3?.message,
    );
  }
}

class FormStockField extends StatelessWidget {
  const FormStockField({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final bloc = context.read<ProductFormBloc>();

    final data = context.select<ProductFormBloc, (String, StockError?)>((bloc) => (bloc.state.stock, bloc.stockError));

    return CustomInput(
      label: t.form.stock,
      initialValue: data.$1,
      keyboardType: TextInputType.number,
      inputFormatters: [StockInputFormatter()],
      onChanged: (value) => bloc.add(ProductFormFieldChanged(ProductField.stock, value)),
      onBlur: () => bloc.add(const ProductFormFieldBlurred(ProductField.stock)),
      errorText: data.$2?.message,
    );
  }
}

class FormCurrencyField extends StatelessWidget {
  const FormCurrencyField({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final bloc = context.read<ProductFormBloc>();

    final currency = context.select<ProductFormBloc, Currency>((bloc) => bloc.state.currency);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          t.form.currency,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: context.colors.ink2),
        ),
        AppSegmented<Currency>(
          segments: [for (final currency in Currency.values) AppSegment(value: currency, label: currency.code)],
          selected: currency,
          onChanged: (value) => bloc.add(ProductFormCurrencyChanged(value)),
        ),
      ],
    );
  }
}
