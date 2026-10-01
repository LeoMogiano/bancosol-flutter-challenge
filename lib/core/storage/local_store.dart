import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/services/logger_service.dart';

abstract final class StoreBox {
  static const String settings = 'settings';
  static const String productsCache = 'products_cache';

  static const List<String> all = [settings, productsCache];
}

abstract interface class LocalStore {
  T? read<T>(String box, String key);

  Future<void> write(String box, String key, Object? value);

  Future<void> delete(String box, String key);
}

class HiveLocalStore implements LocalStore {
  static Future<void> init() async {
    await Hive.initFlutter();
    for (final name in StoreBox.all) {
      try {
        await Hive.openBox<dynamic>(name);
      } on Object catch (e, s) {
        // Caja corrupta: se descarta (solo cache y preferencias) para que la app siempre arranque.
        LoggerService.e('Caja "$name" corrupta: se borró y se recrea vacía', name: 'STORE', error: e, stackTrace: s);
        await Hive.deleteBoxFromDisk(name);
        await Hive.openBox<dynamic>(name);
      }
    }
  }

  Box<dynamic> _box(String name) => Hive.box<dynamic>(name);

  @override
  T? read<T>(String box, String key) {
    try {
      final value = _box(box).get(key);
      return value is T ? value : null;
    } on Object catch (e) {
      throw Failure(FailureType.cache, detail: InternalDetail('read $box/$key: $e'));
    }
  }

  @override
  Future<void> write(String box, String key, Object? value) async {
    try {
      await _box(box).put(key, value);
    } on Object catch (e) {
      throw Failure(FailureType.cache, detail: InternalDetail('write $box/$key: $e'));
    }
  }

  @override
  Future<void> delete(String box, String key) async {
    try {
      await _box(box).delete(key);
    } on Object catch (e) {
      throw Failure(FailureType.cache, detail: InternalDetail('delete $box/$key: $e'));
    }
  }
}
