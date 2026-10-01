import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/i18n/strings.g.dart';

extension FailureI18n on Failure {
  String get message => switch (type) {
    FailureType.network => t.failures.network,
    FailureType.timeout => t.failures.timeout,
    FailureType.notFound => t.failures.notFound,
    FailureType.rateLimit => t.failures.rateLimit,
    FailureType.server => t.failures.server,
    FailureType.cache => t.failures.cache,
    FailureType.parse || FailureType.unexpected => t.failures.unexpected,
  };
}
