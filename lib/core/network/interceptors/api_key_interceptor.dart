import 'package:dio/dio.dart';

class ApiKeyInterceptor extends Interceptor {
  ApiKeyInterceptor(this.apiKey);

  static const String header = 'x-api-key';

  final String apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (apiKey.isNotEmpty) options.headers[header] = apiKey;
    handler.next(options);
  }
}
