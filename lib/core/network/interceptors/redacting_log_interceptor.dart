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

  static const _maxBody = 2000;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['t0'] = DateTime.now().millisecondsSinceEpoch;

    LoggerService.d('➡️ Request: [${options.method}] ${redactUrl(options.uri)}', name: 'HTTP');
    final body = _redactBody(options.data);
    if (body.isNotEmpty) LoggerService.d('Body: $body', name: 'HTTP');

    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final options = response.requestOptions;

    LoggerService.s(
      'Response: [${response.statusCode}] ${options.method} ${redactUrl(options.uri)} (${_elapsed(options)}ms)',
      name: 'HTTP',
    );
    final data = _redactBody(response.data);
    if (data.isNotEmpty) LoggerService.d('Data: $data', name: 'HTTP');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final req = err.requestOptions;
    final res = err.response;

    LoggerService.log('🚨 ERROR EN REQUEST', name: 'HTTP');
    LoggerService.log('➡️ ${req.method} ${redactUrl(req.uri)} (${_elapsed(req)}ms)', name: 'HTTP');
    final body = _redactBody(req.data);
    if (body.isNotEmpty) LoggerService.log('Body: $body', name: 'HTTP');

    if (res != null) {
      LoggerService.log('⬅️ Status: ${res.statusCode}', name: 'HTTP');
      final data = _redactBody(res.data);
      if (data.isNotEmpty) LoggerService.log('Response: $data', name: 'HTTP');
    }

    LoggerService.log('❌ Error: ${err.message ?? err.type.name}', name: 'HTTP');

    handler.next(err);
  }

  int _elapsed(RequestOptions options) {
    final t0 = options.extra['t0'] as int?;
    return t0 != null ? DateTime.now().millisecondsSinceEpoch - t0 : 0;
  }

  String _redactBody(Object? body) {
    final out = switch (body) {
      String() => redact(body),
      Map() || List() => redact(jsonEncode(body)),
      _ => '',
    };
    return out.length > _maxBody ? out.substring(0, _maxBody) : out;
  }

  @visibleForTesting
  static String redactUrl(Uri uri) {
    if (!uri.hasQuery) return '$uri';
    return uri
        .replace(
          queryParameters: {
            for (final e in uri.queryParametersAll.entries) e.key: _sensitivePattern.hasMatch(e.key) ? '***' : e.value,
          },
        )
        .toString();
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
    if (value is List) return value.map(_redactJsonValue).toList();
    return value;
  }
}
