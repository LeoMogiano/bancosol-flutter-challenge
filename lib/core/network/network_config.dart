abstract final class NetworkConfig {
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const int maxRetries = 2;
  static const Duration retryBaseDelay = Duration(milliseconds: 400);
  static const Duration maxRetryAfter = Duration(seconds: 3);
}
