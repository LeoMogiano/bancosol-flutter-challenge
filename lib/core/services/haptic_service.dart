import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// iOS sigue el HIG de Apple; Android usa las constantes del sistema y solo en equipos con actuador háptico real.
abstract final class HapticService {
  static const MethodChannel _android = MethodChannel('app/haptics');

  static void selection() => _play(HapticFeedback.selectionClick, 'selection');

  static void toggle({required bool on}) => _play(HapticFeedback.lightImpact, on ? 'toggleOn' : 'toggleOff');

  static void refresh() => _play(HapticFeedback.lightImpact, 'refresh');

  static void success() => _play(HapticFeedback.successNotification, 'success');

  static void error() => _play(HapticFeedback.errorNotification, 'error');

  static void _play(Future<void> Function() ios, String android) {
    if (kIsWeb) return;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        unawaited(ios());
      case TargetPlatform.android:
        _android.invokeMethod<void>('play', android).ignore();
      case TargetPlatform.fuchsia || TargetPlatform.linux || TargetPlatform.macOS || TargetPlatform.windows:
        break;
    }
  }
}
