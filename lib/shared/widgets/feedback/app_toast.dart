import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/app_dimens.dart';
import 'package:warehouse/core/theme/theme_context.dart';

abstract final class AppToast {
  static OverlayEntry? _current;
  static Timer? _timer;

  static void show(BuildContext context, String message, {IconData icon = Icons.check_circle_rounded}) {
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
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 200),
              builder: (_, opacity, child) => Opacity(opacity: opacity, child: child),
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
