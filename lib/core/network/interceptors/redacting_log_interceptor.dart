import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:warehouse/core/utils/logger_service.dart';

class RedactingLogInterceptor extends Interceptor {
  static final _sensitivePattern = RegExp(
    '(password|token|refreshToken|refresh_token|accessToken|access_token|'
    'api_key|apiKey|x-api-key)',
    caseSensitive: false,
  );

  // Los agrega sentry_dio en el adapter; solo aparecían al reintentar, cuando el options ya los trae. Ruido en el log.
  static const _hiddenHeaders = {'sentry-trace', 'baggage'};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['t0'] = DateTime.now().millisecondsSinceEpoch;

    final redactedHeaders = _redactHeaders(options.headers);
    final body = options.data;
    final redactedBody = _redactBody(body);

    LoggerService.d('→ ${options.method} ${options.path}', name: 'HTTP');
    if (redactedHeaders.isNotEmpty) {
      LoggerService.d('Headers: $redactedHeaders', name: 'HTTP');
    }
    if (redactedBody.isNotEmpty) {
      LoggerService.d('Body: $redactedBody', name: 'HTTP');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final t0 = response.requestOptions.extra['t0'] as int?;
    final duration = t0 != null ? DateTime.now().millisecondsSinceEpoch - t0 : 0;

    final body = response.data;
    var redactedBody = _redactBody(body);

    if (redactedBody.length > 2000) {
      redactedBody = redactedBody.substring(0, 2000);
    }

    LoggerService.d('← ${response.statusCode} ${response.requestOptions.path} (${duration}ms)', name: 'HTTP');
    if (redactedBody.isNotEmpty) {
      LoggerService.d('Body: $redactedBody', name: 'HTTP');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final statusOrType = status ?? err.type.name;

    LoggerService.d('✖ $statusOrType ${err.requestOptions.path}', name: 'HTTP');

    super.onError(err, handler);
  }

  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    final redacted = <String, dynamic>{};
    headers.forEach((key, value) {
      final name = key.toLowerCase();
      if (_hiddenHeaders.contains(name)) return;
      if (name == 'x-api-key' || name == 'authorization') {
        redacted[key] = '***';
      } else {
        redacted[key] = value;
      }
    });
    return redacted;
  }

  String _redactBody(Object? body) {
    if (body == null) return '';
    if (body is String) return redact(body);
    if (body is Map || body is List) {
      return redact(jsonEncode(body));
    }
    return '';
  }

  @visibleForTesting
  static String redact(String input) {
    try {
      final json = jsonDecode(input);
      final redacted = _redactJsonValue(json);
      return jsonEncode(redacted);
    } on Object {
      return input;
    }
  }

  static Object? _redactJsonValue(Object? value) {
    if (value is Map) {
      final redacted = <String, Object?>{};
      value.forEach((key, val) {
        final keyStr = key.toString();
        if (_sensitivePattern.hasMatch(keyStr)) {
          redacted[keyStr] = '***';
        } else {
          redacted[keyStr] = _redactJsonValue(val);
        }
      });
      return redacted;
    }
    if (value is List) {
      return value.map(_redactJsonValue).toList();
    }
    return value;
  }
}
