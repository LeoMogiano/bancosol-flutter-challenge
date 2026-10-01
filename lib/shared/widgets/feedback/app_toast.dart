import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/app_dimens.dart';
import 'package:warehouse/core/theme/theme_context.dart';

abstract final class AppToast {
  static OverlayEntry? _current;
  static Timer? _timer;

  static void showSuccess(BuildContext context, String message, {IconData icon = Icons.check_circle_rounded}) =>
      _show(context, message, icon);

  static void showError(BuildContext context, String message) => _show(context, message, Icons.error_rounded);

  static void showInfo(BuildContext context, String message, {IconData icon = Icons.info_outline_rounded}) =>
      _show(context, message, icon);

  static void _show(BuildContext context, String message, IconData icon) {
    _dismiss();
    final colors = context.colors;
    final top = MediaQuery.paddingOf(context).top + 8;
    final entry = OverlayEntry(
      builder: (_) => Positioned(
        top: top,
        left: 16,
        right: 16,
        child: IgnorePointer(
          child: Center(
            child: _FadeIn(
              child: Material(
                color: colors.ink,
                elevation: 6,
                shape: const StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 18, color: colors.bg),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          message,
                          style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w500, color: colors.bg),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(entry);
    _current = entry;
    _timer = Timer(AppMotion.toast, () {
      if (identical(_current, entry)) _dismiss();
    });
  }

  static void _dismiss() {
    _timer?.cancel();
    _current?.remove();
    _current = null;
  }
}

// FadeTransition anima la opacidad en la capa sin repintar el toast en cada frame.
class _FadeIn extends StatefulWidget {
  const _FadeIn({required this.child});

  final Widget child;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _controller, child: widget.child);
}
