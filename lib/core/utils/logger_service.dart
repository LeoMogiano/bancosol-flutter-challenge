import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

// No-op en release; la telemetría va por Sentry, no por aquí.
abstract final class LoggerService {
  static void log(String message, {String? name, Object? error, StackTrace? stackTrace}) =>
      _emit(message, name: name, level: 800, error: error, stackTrace: stackTrace);

  static void d(String message, {String? name}) => _emit('🐛 $message', name: name, level: 500);

  static void i(String message, {String? name}) => _emit('💡 $message', name: name, level: 800);

  static void s(String message, {String? name}) => _emit('✅ $message', name: name, level: 800);

  static void w(String message, {String? name}) => _emit('⚠️ $message', name: name, level: 900);

  static void e(String message, {String? name, Object? error, StackTrace? stackTrace}) =>
      _emit('⛔ $message', name: name, level: 1000, error: error, stackTrace: stackTrace);

  static void _emit(String message, {required int level, String? name, Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    developer.log(message, name: name ?? 'APP', level: level, error: error, stackTrace: stackTrace);
  }
}
