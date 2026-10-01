import 'dart:async';

import 'package:dio/dio.dart';
import 'package:warehouse/core/network/network_config.dart';
import 'package:warehouse/core/network/replays_requests.dart';

class RetryInterceptor extends Interceptor implements ReplaysRequests {
  RetryInterceptor({Future<void> Function(Duration)? sleep}) : _sleep = sleep ?? Future<void>.delayed;

  static const _attemptKey = 'retry_attempt';
  // POST queda fuera: reintentarlo podría crear productos duplicados.
  static const _idempotent = {'GET', 'PUT', 'DELETE', 'HEAD'};

  final Future<void> Function(Duration) _sleep;
  Dio? _dio;

  @override
  set replayClient(Dio dio) => _dio = dio;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final attempt = options.extra[_attemptKey] as int? ?? 0;
    final dio = _dio;
    if (dio == null || attempt >= NetworkConfig.maxRetries || !_shouldRetry(err)) {
      return handler.next(err);
    }

    await _sleep(_delay(err, attempt));
    options.extra[_attemptKey] = attempt + 1;
    try {
      handler.resolve(await dio.fetch<Object?>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    if (!_idempotent.contains(err.requestOptions.method.toUpperCase())) return false;
    final status = err.response?.statusCode ?? 0;
    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      DioExceptionType.badResponse => status == 429 || status >= 500,
      _ => false,
    };
  }

  Duration _delay(DioException err, int attempt) {
    final retryAfter = int.tryParse(err.response?.headers.value('retry-after') ?? '');
    if (retryAfter != null) {
      final wait = Duration(seconds: retryAfter);
      return wait > NetworkConfig.maxRetryAfter ? NetworkConfig.maxRetryAfter : wait;
    }
    return NetworkConfig.retryBaseDelay * (1 << attempt);
  }
}
