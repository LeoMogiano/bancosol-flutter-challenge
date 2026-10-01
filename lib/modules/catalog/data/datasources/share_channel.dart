import 'package:flutter/services.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/repositories/share_repository.dart';

class ShareChannel implements ShareRepository {
  ShareChannel([MethodChannel? channel]) : _channel = channel ?? const MethodChannel('app/share');

  final MethodChannel _channel;

  @override
  Future<bool> shareProduct(Product product, {required String text}) async {
    try {
      final shared = await _channel.invokeMethod<bool>('shareProduct', {
        'name': product.name,
        'price': product.price.toStringAsFixed(2),
        'currency': product.currency,
        'sku': product.sku,
        'text': text,
      });
      return shared ?? false;
    } on PlatformException catch (e) {
      throw Failure(FailureType.unexpected, detail: InternalDetail(e.code));
    } on MissingPluginException {
      throw const Failure(FailureType.unexpected, detail: InternalDetail('Plugin not found'));
    }
  }
}
