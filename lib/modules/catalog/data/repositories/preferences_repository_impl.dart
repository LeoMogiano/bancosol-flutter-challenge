import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/storage/keys/settings_key.dart';
import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/core/utils/logger_service.dart';
import 'package:warehouse/modules/catalog/domain/entities/app_preferences.dart';
import 'package:warehouse/modules/catalog/domain/repositories/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  PreferencesRepositoryImpl(this._store);

  final LocalStore _store;

  // En memoria primero: si el disco falla, la preferencia igual vale para esta sesión.
  late AppPreferences _current = AppPreferences(
    themeMode: AppThemeMode.values.asNameMap()[_store.read<String>(SettingsKey.themeMode)] ?? AppThemeMode.light,
    languageCode: _store.read<String>(SettingsKey.languageCode),
    cacheEnabled: _store.read<bool>(SettingsKey.cacheEnabled) ?? true,
  );

  @override
  AppPreferences load() => _current;

  @override
  Future<void> saveThemeMode(AppThemeMode themeMode) {
    _current = _current.copyWith(themeMode: themeMode);
    return _persist(SettingsKey.themeMode, themeMode.name);
  }

  @override
  Future<void> saveLanguage(String? languageCode) {
    _current = _current.copyWith(languageCode: () => languageCode);
    return _persist(SettingsKey.languageCode, languageCode);
  }

  @override
  Future<void> saveCacheEnabled({required bool enabled}) {
    _current = _current.copyWith(cacheEnabled: enabled);
    return _persist(SettingsKey.cacheEnabled, enabled);
  }

  Future<void> _persist(SettingsKey key, Object? value) async {
    try {
      value == null ? await _store.delete(key) : await _store.write(key, value);
    } on Failure catch (f) {
      LoggerService.w('No se guardó ${key.id}: ${f.detail?.value}', name: 'PREFS');
    }
  }
}
