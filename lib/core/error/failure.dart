import 'package:equatable/equatable.dart';

enum FailureType { network, timeout, notFound, rateLimit, server, parse, cache, unexpected }

class Failure extends Equatable implements Exception {
  const Failure(this.type, {this.statusCode, this.detail});

  final FailureType type;
  final int? statusCode;
  final InternalDetail? detail;

  @override
  List<Object?> get props => [type, statusCode];

  @override
  String toString() => 'Failure(${type.name}${statusCode == null ? '' : ', $statusCode'})';
}

// toString oculta el valor para que nunca termine en un Text(); leer `.value` explícitamente.
class InternalDetail {
  const InternalDetail(this.value);

  final String value;

  @override
  String toString() => '[internal]';
}
