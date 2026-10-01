import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/services/logger_service.dart';
import 'package:warehouse/core/storage/keys/store_box.dart';
import 'package:warehouse/core/storage/keys/store_key.dart';

abstract interface class LocalStore {
  T? read<T>(StoreKey key);

  Future<void> write(StoreKey key, Object? value);

  Future<void> delete(StoreKey key);
}

class HiveLocalStore implements LocalStore {
  static Future<void> init() async {
    await Hive.initFlutter();
    for (final name in StoreBox.values.map((b) => b.id)) {
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

  Box<dynamic> _box(StoreKey key) => Hive.box<dynamic>(key.box.id);

  @override
  T? read<T>(StoreKey key) {
    try {
      final value = _box(key).get(key.id);
      return value is T ? value : null;
    } on Object catch (e) {
      throw Failure(FailureType.cache, detail: InternalDetail('read ${key.box.id}/${key.id}: $e'));
    }
  }

  @override
  Future<void> write(StoreKey key, Object? value) async {
    try {
      await _box(key).put(key.id, value);
    } on Object catch (e) {
      throw Failure(FailureType.cache, detail: InternalDetail('write ${key.box.id}/${key.id}: $e'));
    }
  }

  @override
  Future<void> delete(StoreKey key) async {
    try {
      await _box(key).delete(key.id);
    } on Object catch (e) {
      throw Failure(FailureType.cache, detail: InternalDetail('delete ${key.box.id}/${key.id}: $e'));
    }
  }
}
