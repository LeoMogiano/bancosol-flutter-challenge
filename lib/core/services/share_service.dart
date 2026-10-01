import 'package:flutter/services.dart';
import 'package:warehouse/core/error/failure.dart';

class ShareService {
  ShareService([MethodChannel? channel]) : _channel = channel ?? const MethodChannel('app/share');

  final MethodChannel _channel;

  // true solo si la plataforma confirma que se compartió (Android no informa: devuelve false).
  Future<bool> shareText(String text, {String? subject}) async {
    try {
      final shared = await _channel.invokeMethod<bool>('shareText', {'text': text, 'subject': subject});
      return shared ?? false;
    } on PlatformException catch (e) {
      throw Failure(FailureType.unexpected, detail: InternalDetail(e.code));
    } on MissingPluginException {
      throw const Failure(FailureType.unexpected, detail: InternalDetail('Plugin not found'));
    }
  }
}
