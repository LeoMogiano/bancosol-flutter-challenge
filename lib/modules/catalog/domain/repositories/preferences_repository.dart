import 'package:warehouse/modules/catalog/domain/entities/app_preferences.dart';

abstract interface class PreferencesRepository {
  AppPreferences load();

  Future<void> saveThemeMode(AppThemeMode themeMode);

  Future<void> saveLanguage(AppLanguage? language);

  Future<void> saveCacheEnabled({required bool enabled});
}
