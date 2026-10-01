import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/data/datasources/share_channel.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ShareChannel', () {
    late ShareChannel shareChannel;

    const product = Product(
      remoteId: 'id1',
      id: 1,
      sku: 'SKU-001',
      name: 'Test Product',
      price: 150.50,
      currency: 'BOB',
      stock: 10,
    );

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('app/share'),
        (call) async {
          if (call.method == 'shareProduct') {
            final args = call.arguments as Map<dynamic, dynamic>;
            expect(args['name'], 'Test Product');
            expect(args['price'], '150.50');
            expect(args['sku'], 'SKU-001');
            expect(args['currency'], 'BOB');
            expect(args['text'], 'Share text');
            return null;
          }
          return null;
        },
      );

      shareChannel = ShareChannel();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('app/share'),
        null,
      );
    });

    test('envía nombre, precio, SKU y el texto estructurado por el canal nativo', () async {
      await shareChannel.shareProduct(product, text: 'Share text');
    });

    test('si la plataforma falla, sale como Failure (no PlatformException)', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('app/share'),
        (call) async {
          throw PlatformException(code: 'SHARE_FAILED', message: 'Share failed');
        },
      );

      expect(() => shareChannel.shareProduct(product, text: 'Share text'), throwsA(isA<Failure>()));
    });
  });
}
