import 'package:flutter/services.dart';

enum Environment { dev, qa, prod }

abstract final class EnvConfig {
  static const String _baseUrl = String.fromEnvironment('BASE_URL');
  static const String apiKey = String.fromEnvironment('API_KEY');
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

  static const String _flavor = appFlavor ?? 'dev';

  static final Environment env = switch (_flavor) {
    'prod' => Environment.prod,
    'qa' => Environment.qa,
    _ => Environment.dev,
  };

  static bool get isProd => env == Environment.prod;

  // Falla al arrancar con un mensaje legible, y no en la primera petición.
  static void validate() => baseUrl;

  static String get baseUrl {
    if (_baseUrl.isEmpty) throw StateError('BASE_URL vacío. Ejecuta con --dart-define-from-file=.env.<flavor>.');
    return _baseUrl;
  }
}
