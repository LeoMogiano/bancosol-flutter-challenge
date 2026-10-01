import 'package:warehouse/core/storage/keys/store_box.dart';
import 'package:warehouse/core/storage/keys/store_key.dart';

enum SettingsKey implements StoreKey {
  themeMode('theme_mode'),
  languageCode('locale'),
  cacheEnabled('cache_enabled');

  SettingsKey(this.id);

  @override
  final String id;

  @override
  StoreBox get box => StoreBox.settings;
}
