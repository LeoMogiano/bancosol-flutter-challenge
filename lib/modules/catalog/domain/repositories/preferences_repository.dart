import 'package:warehouse/modules/catalog/domain/entities/app_preferences.dart';

abstract interface class PreferencesRepository {
  AppPreferences load();

  Future<void> saveThemeMode(AppThemeMode themeMode);

  Future<void> saveLanguage(String? languageCode);

  Future<void> saveCacheEnabled({required bool enabled});
}
