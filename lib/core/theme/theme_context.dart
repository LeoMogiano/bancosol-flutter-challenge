import 'package:flutter/material.dart';
import 'package:warehouse/core/theme/app_colors.dart';

extension ThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
