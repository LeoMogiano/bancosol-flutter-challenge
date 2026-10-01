import 'dart:async';

import 'package:warehouse/core/utils/app_clock.dart';

class Debouncer {
  Debouncer({required this.delay, this._clock = const AppClock()});

  final Duration delay;

  final AppClock _clock;
  Timer? _timer;

  void run(void Function() action) {
    cancel();
    _timer = _clock.timer(delay, () {
      action();
      _timer = null;
    });
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isPending => _timer != null;

  void dispose() {
    cancel();
  }
}
