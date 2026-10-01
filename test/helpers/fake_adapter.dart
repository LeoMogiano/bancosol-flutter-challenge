import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef FakeReply = ResponseBody Function(RequestOptions options);

class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this._replies);

  FakeAdapter.json(Object? body, {int status = 200}) : this([(_) => jsonBody(body, status: status)]);

  final List<FakeReply> _replies;
  int calls = 0;

  static ResponseBody jsonBody(Object? body, {int status = 200}) => ResponseBody.fromString(
    body == null ? '' : jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final reply = _replies[calls.clamp(0, _replies.length - 1)];
    calls++;
    return reply(options);
  }

  @override
  void close({bool force = false}) {}
}
