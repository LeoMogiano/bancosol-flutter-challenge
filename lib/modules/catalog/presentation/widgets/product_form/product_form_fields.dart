import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/product_form/product_form_cubit.dart';
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
    final cubit = context.read<ProductFormCubit>();

    final data = context.select<ProductFormCubit, (String, SkuError?)>((bloc) => (bloc.state.sku, bloc.skuError));

    return CustomInput(
      label: t.form.sku,
      initialValue: data.$1,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [SkuInputFormatter()],
      onChanged: cubit.skuChanged,
      onBlur: () => cubit.fieldBlurred(ProductField.sku),
      errorText: data.$2?.message,
    );
  }
}

class FormNameField extends StatelessWidget {
  const FormNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cubit = context.read<ProductFormCubit>();

    final data = context.select<ProductFormCubit, (String, NameError?)>((bloc) => (bloc.state.name, bloc.nameError));

    return CustomInput(
      label: t.form.name,
      initialValue: data.$1,
      inputFormatters: [NameInputFormatter()],
      onChanged: cubit.nameChanged,
      onBlur: () => cubit.fieldBlurred(ProductField.name),
      errorText: data.$2?.message,
    );
  }
}

class FormPriceField extends StatelessWidget {
  const FormPriceField({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cubit = context.read<ProductFormCubit>();

    final data = context.select<ProductFormCubit, (String, String, PriceError?)>(
      (bloc) => (bloc.state.price, bloc.state.currency, bloc.priceError),
    );

    return PriceField(
      label: t.form.price,
      currency: data.$2,
      initialValue: data.$1,
      onChanged: cubit.priceChanged,
      onBlur: () => cubit.fieldBlurred(ProductField.price),
      errorText: data.$3?.message,
    );
  }
}

class FormStockField extends StatelessWidget {
  const FormStockField({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cubit = context.read<ProductFormCubit>();

    final data = context.select<ProductFormCubit, (String, StockError?)>((bloc) => (bloc.state.stock, bloc.stockError));

    return CustomInput(
      label: t.form.stock,
      initialValue: data.$1,
      keyboardType: TextInputType.number,
      inputFormatters: [StockInputFormatter()],
      onChanged: cubit.stockChanged,
      onBlur: () => cubit.fieldBlurred(ProductField.stock),
      errorText: data.$2?.message,
    );
  }
}

class FormCurrencyField extends StatelessWidget {
  const FormCurrencyField({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cubit = context.read<ProductFormCubit>();

    final currency = context.select<ProductFormCubit, String>((bloc) => bloc.state.currency);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          t.form.currency,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: context.colors.ink2),
        ),
        AppSegmented<String>(
          segments: const [
            AppSegment(value: 'BOB', label: 'BOB'),
            AppSegment(value: 'USD', label: 'USD'),
          ],
          selected: currency,
          onChanged: cubit.currencyChanged,
        ),
      ],
    );
  }
}
