import 'package:flutter/animation.dart';

abstract final class AppSpacing {
  static const double screenH = 20;
  static const double listGap = 8;
}

abstract final class AppMotion {
  static const Curve emphasized = Cubic(0.2, 0.8, 0.2, 1);
  static const Duration detail = Duration(milliseconds: 400);
  static const Duration toast = Duration(seconds: 2);
  static const Duration debounce = Duration(milliseconds: 350);

  static const AnimationStyle sheet = AnimationStyle(
    duration: Duration(milliseconds: 380),
    reverseDuration: Duration(milliseconds: 300),
    curve: emphasized,
  );
}
