import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/shared/formatters/price_input_formatter.dart';
import 'package:warehouse/shared/widgets/inputs/custom_input.dart';

class PriceField extends StatelessWidget {
  const PriceField({
    required this.currency,
    this.label,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onBlur,
    this.errorText,
    this.helperText,
    this.helperIsWarning = false,
    this.large = false,
    this.autofocus = false,
    super.key,
  });

  final String currency;
  final String? label;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onBlur;
  final String? errorText;
  final String? helperText;
  final bool helperIsWarning;
  final bool large;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return CustomInput(
      label: label,
      controller: controller,
      initialValue: initialValue,
      autofocus: autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [PriceInputFormatter()],
      onChanged: onChanged,
      onBlur: onBlur,
      errorText: errorText,
      helperText: helperText,
      helperIsWarning: helperIsWarning,
      large: large,
      suffixIcon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 40,
        decoration: BoxDecoration(color: colors.bg, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currency,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: colors.ink2),
            ),
            const SizedBox(width: 4),
            Icon(Icons.lock_rounded, size: 14, color: colors.ink3),
          ],
        ),
      ),
    );
  }
}
