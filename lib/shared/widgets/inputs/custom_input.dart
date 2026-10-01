import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class CustomInput extends StatefulWidget {
  const CustomInput({
    this.label,
    this.hintText,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.autofocus = false,
    this.onChanged,
    this.onBlur,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.helperText,
    this.helperIsWarning = false,
    this.large = false,
    this.readOnly = false,
    this.onTap,
    super.key,
  });

  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onBlur;
  final ValueChanged<String>? onSubmitted;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final String? helperText;
  final bool helperIsWarning;
  final bool large;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final ValueNotifier<bool> _hasFocus = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(CustomInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.initialValue;
    if (widget.controller == null && next != null && next != oldWidget.initialValue && next != _controller.text) {
      _controller.text = next;
    }
  }

  void _handleFocusChange() {
    _hasFocus.value = _focusNode.hasFocus;
    if (!_focusNode.hasFocus) {
      widget.onBlur?.call();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    _hasFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final height = widget.large ? 62.0 : 52.0;
    // Un errorText vacío marca el borde en rojo sin mensaje (p. ej. el rango mínimo/máximo).
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: colors.ink2),
          ),
          const SizedBox(height: 8),
        ],
        ValueListenableBuilder<bool>(
          valueListenable: _hasFocus,
          builder: (context, hasFocus, _) {
            final borderColor = hasError ? colors.bad : (hasFocus ? colors.accent : colors.line);

            return Container(
              constraints: BoxConstraints(minHeight: height),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (widget.prefixIcon != null) ...[widget.prefixIcon!, const SizedBox(width: 8)],
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: widget.autofocus,
                      readOnly: widget.readOnly,
                      onChanged: widget.onChanged,
                      onSubmitted: widget.onSubmitted,
                      onTap: widget.onTap,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      textCapitalization: widget.textCapitalization,
                      inputFormatters: widget.inputFormatters,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hintText,
                        hintStyle: TextStyle(fontSize: widget.large ? 19.65.sp : 15.sp, color: colors.ink3),
                      ),
                      style: TextStyle(fontSize: widget.large ? 19.65.sp : 15.sp, color: colors.ink),
                    ),
                  ),
                  if (widget.suffixIcon != null) ...[const SizedBox(width: 8), widget.suffixIcon!],
                ],
              ),
            );
          },
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: colors.bad),
          ),
        ] else if (widget.helperText != null && widget.helperText!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            widget.helperText!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: widget.helperIsWarning ? colors.warn : colors.ink3,
            ),
          ),
        ],
      ],
    );
  }
}
