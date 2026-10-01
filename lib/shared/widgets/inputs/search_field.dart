import 'package:flutter/material.dart';
import 'package:warehouse/core/theme/app_dimens.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/core/utils/debouncer.dart';
import 'package:warehouse/shared/widgets/inputs/custom_input.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    required this.onChanged,
    this.hintText,
    this.initialValue = '',
    this.focusNode,
    this.controller,
    this.trailing,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final String? hintText;
  final String initialValue;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Widget? trailing;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  static const double _spinnerSize = 16;
  static const double _dividerHeight = 24;

  late final TextEditingController _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
  final _debouncer = Debouncer(delay: AppMotion.debounce);
  final ValueNotifier<bool> _pending = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  // Si el texto se vacía (incluso desde afuera), una búsqueda pendiente no debe reaplicar la consulta vieja.
  void _onTextChanged() {
    if (_controller.text.isEmpty && _debouncer.isPending) {
      _debouncer.cancel();
      _pending.value = false;
    }
  }

  void _onChanged(String value) {
    if (value.isEmpty) {
      widget.onChanged('');
      return;
    }
    _pending.value = true;
    _debouncer.run(() {
      _pending.value = false;
      widget.onChanged(value);
    });
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) _controller.dispose();
    _debouncer.dispose();
    _pending.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final trailing = widget.trailing;
    return CustomInput(
      controller: _controller,
      focusNode: widget.focusNode,
      hintText: widget.hintText,
      textInputAction: TextInputAction.search,
      onChanged: _onChanged,
      pill: true,
      prefixIcon: Icon(Icons.search_rounded, size: 22, color: colors.ink2),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListenableBuilder(
            listenable: Listenable.merge([_pending, _controller]),
            builder: (context, _) {
              if (_pending.value) {
                return Center(
                  widthFactor: 1,
                  child: SizedBox.square(
                    dimension: _spinnerSize,
                    child: CircularProgressIndicator(strokeWidth: 2, color: colors.accent),
                  ),
                );
              }
              if (_controller.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                onPressed: _clear,
                tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                icon: Icon(Icons.close_rounded, size: 18, color: colors.ink3),
              );
            },
          ),
          if (trailing != null) ...[
            Container(
              width: 1,
              height: _dividerHeight,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: colors.line,
            ),
            trailing,
          ],
        ],
      ),
    );
  }
}
