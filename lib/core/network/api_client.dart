import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/network/network_config.dart';
import 'package:warehouse/core/utils/logger_service.dart';

typedef Decoder<T> = T Function(Object? data);
typedef ItemDecoder<T> = T Function(Map<String, Object?> json);

class ApiClient {
  ApiClient({required String baseUrl, List<Interceptor> interceptors = const [], HttpClientAdapter? adapter})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: NetworkConfig.connectTimeout,
          sendTimeout: NetworkConfig.sendTimeout,
          receiveTimeout: NetworkConfig.receiveTimeout,
          contentType: Headers.jsonContentType,
        ),
      ) {
    if (adapter != null) _dio.httpClientAdapter = adapter;
    _dio.interceptors.addAll(interceptors);
    // Issue solo para bugs reales (payload/verbo mal, backend caído); 404/429 quedan como breadcrumb. Cuida la cuota.
    if (Sentry.isEnabled) {
      _dio.addSentry(
        failedRequestStatusCodes: [SentryStatusCode(400), SentryStatusCode(405), SentryStatusCode.range(500, 599)],
      );
    }
  }

  final Dio _dio;

  @visibleForTesting
  Dio get dio => _dio;

  Future<T> get<T>(String path, {required Decoder<T> decode, Map<String, Object?>? query}) =>
      _send('GET', path, () => _dio.get<Object?>(path, queryParameters: query), decode);

  // Un ítem mal formado se descarta y se reporta como parse: un registro corrupto no vacía la lista.
  Future<List<T>> getList<T>(String path, {required ItemDecoder<T> decodeItem}) => _send(
    'GET',
    path,
    () => _dio.get<Object?>(path),
    (data) => [for (final item in data! as List) ?_tryDecodeItem('GET $path', item, decodeItem)],
  );

  Future<T> post<T>(String path, {required Object? body, required Decoder<T> decode}) =>
      _send('POST', path, () => _dio.post<Object?>(path, data: body), decode);

  Future<void> put(String path, {required Object? body}) =>
      _send('PUT', path, () => _dio.put<Object?>(path, data: body), (_) {});

  Future<void> delete(String path) => _send('DELETE', path, () => _dio.delete<Object?>(path), (_) {});

  Future<T> _send<T>(String method, String path, Future<Response<Object?>> Function() call, Decoder<T> decode) async {
    final Response<Object?> response;
    try {
      response = await call();
    } on DioException catch (e, st) {
      throw _report(_fromDio(method, path, e), e, st);
    }
    try {
      return decode(response.data);
    } on Failure {
      rethrow;
    } on Object catch (e, st) {
      final detail = '$method $path: $e @ ${_firstAppFrame(st)}';
      throw _report(Failure(FailureType.parse, detail: InternalDetail(detail)), e, st);
    }
  }

  T? _tryDecodeItem<T>(String request, Object? item, ItemDecoder<T> decodeItem) {
    try {
      return decodeItem(Map<String, Object?>.from(item! as Map));
    } on Object catch (e, st) {
      _report(
        Failure(FailureType.parse, detail: InternalDetail('$request (ítem descartado): $e @ ${_firstAppFrame(st)}')),
        e,
        st,
      );
      return null;
    }
  }

  Failure _fromDio(String method, String path, DioException e) {
    if (e.error is Failure) return e.error! as Failure;
    final status = e.response?.statusCode;
    final detail = InternalDetail('$method $path → ${status ?? e.type.name}');
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => Failure(FailureType.timeout, detail: detail),
      DioExceptionType.connectionError => Failure(FailureType.network, detail: detail),
      DioExceptionType.unknown when e.error is SocketException => Failure(FailureType.network, detail: detail),
      DioExceptionType.badResponse => Failure(
        switch (status) {
          404 => FailureType.notFound,
          429 => FailureType.rateLimit,
          _ => FailureType.server,
        },
        statusCode: status,
        detail: detail,
      ),
      _ => Failure(FailureType.unexpected, detail: detail),
    };
  }

  // Solo parse/unexpected son bugs nuestros; el resto es esperable y ya queda como breadcrumb.
  Failure _report(Failure failure, Object error, StackTrace stackTrace) {
    LoggerService.w('${failure.type.name} ${failure.detail?.value}', name: 'HTTP');
    if (failure.type == FailureType.parse || failure.type == FailureType.unexpected) {
      unawaited(Sentry.captureException(error, stackTrace: stackTrace));
    }
    return failure;
  }

  // Primer frame fuera del SDK y de este archivo: apunta al DTO que no supo leer la respuesta.
  static String _firstAppFrame(StackTrace stackTrace) => stackTrace
      .toString()
      .split('\n')
      .firstWhere((line) => !line.contains('(dart:') && !line.contains('api_client.dart'), orElse: () => '?')
      .trim();
}
