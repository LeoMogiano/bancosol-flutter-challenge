import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/services/share_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('app/share');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('envía texto y asunto por el canal nativo y devuelve la confirmación', () async {
    MethodCall? received;
    messenger.setMockMethodCallHandler(channel, (call) async {
      received = call;
      return true;
    });

    final shared = await ShareService().shareText('Share text', subject: 'Test Product');

    expect(shared, isTrue);
    expect(received?.method, 'shareText');
    expect(received?.arguments, {'text': 'Share text', 'subject': 'Test Product'});
  });

  test('si la plataforma falla, sale como Failure (no PlatformException)', () async {
    messenger.setMockMethodCallHandler(channel, (_) async => throw PlatformException(code: 'SHARE_FAILED'));

    expect(() => ShareService().shareText('Share text'), throwsA(isA<Failure>()));
  });
}
