import 'dart:async';

// También crea timers: fake_async no compone bien con blocTest.
class AppClock {
  const AppClock();

  int nowMs() => DateTime.now().millisecondsSinceEpoch;

  DateTime now() => DateTime.now();

  Timer timer(Duration duration, void Function() callback) => Timer(duration, callback);
}
