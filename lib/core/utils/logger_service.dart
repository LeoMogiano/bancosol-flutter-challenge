import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Consola solo en debug. A Sentry Logs van solo w/e: d/i/s inflarían la cuota sin aportar.
abstract final class LoggerService {
  static void log(String message, {String? name, Object? error, StackTrace? stackTrace}) =>
      _emit(message, name: name, level: 800, error: error, stackTrace: stackTrace);

  static void d(String message, {String? name}) => _emit('🐛 $message', name: name, level: 500);

  static void i(String message, {String? name}) => _emit('💡 $message', name: name, level: 800);

  static void s(String message, {String? name}) => _emit('✅ $message', name: name, level: 800);

  static void w(String message, {String? name}) {
    _emit('⚠️ $message', name: name, level: 900);
    if (Sentry.isEnabled) unawaited(Future.value(Sentry.logger.warn(message, attributes: _attributes(name))));
  }

  static void e(String message, {String? name, Object? error, StackTrace? stackTrace}) {
    _emit('⛔ $message', name: name, level: 1000, error: error, stackTrace: stackTrace);
    if (Sentry.isEnabled) unawaited(Future.value(Sentry.logger.error(message, attributes: _attributes(name, error))));
  }

  static Map<String, SentryAttribute> _attributes(String? name, [Object? error]) => {
    'logger.name': SentryAttribute.string(name ?? 'APP'),
    if (error != null) 'error.type': SentryAttribute.string(error.runtimeType.toString()),
  };

  static void _emit(String message, {required int level, String? name, Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    developer.log(message, name: name ?? 'APP', level: level, error: error, stackTrace: stackTrace);
  }
}
