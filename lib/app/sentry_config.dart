import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:warehouse/core/config/env_config.dart';
import 'package:warehouse/core/network/interceptors/api_key_interceptor.dart';

typedef AppRunner = FutureOr<void> Function();

Future<void> runWithSentry(AppRunner appRunner) async {
  if (EnvConfig.sentryDsn.isEmpty) {
    await appRunner();
    return;
  }
  await SentryFlutter.init(configureSentryOptions, appRunner: appRunner);
}

@visibleForTesting
void configureSentryOptions(SentryFlutterOptions options) {
  options
    ..dsn = EnvConfig.sentryDsn
    ..environment = EnvConfig.isProd ? 'production' : EnvConfig.env.name
    ..tracesSampleRate = EnvConfig.isProd ? 0.2 : 1.0
    ..captureFailedRequests = true
    // Explícito: activarlo enviaría todos los headers, x-api-key incluido.
    ..sendDefaultPii = false
    ..maxRequestBodySize = MaxRequestBodySize.never
    ..attachScreenshot = true
    ..enableLogs = true
    ..beforeBreadcrumb = redactBreadcrumb;
}

@visibleForTesting
Breadcrumb? redactBreadcrumb(Breadcrumb? breadcrumb, Hint hint) {
  final data = breadcrumb?.data;
  if (breadcrumb == null || data == null) return breadcrumb;
  final clean = Map<String, dynamic>.of(data)..remove(ApiKeyInterceptor.header);
  final headers = clean['headers'];
  if (headers is Map) {
    clean['headers'] = Map<String, dynamic>.of(headers.cast<String, dynamic>())..remove(ApiKeyInterceptor.header);
  }
  return breadcrumb..data = clean;
}
