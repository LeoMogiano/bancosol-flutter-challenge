import 'package:warehouse/core/i18n/strings.g.dart';

Future<void> applyAppLocale(String? languageCode) async {
  if (languageCode == null) {
    await LocaleSettings.useDeviceLocale();
  } else {
    await LocaleSettings.setLocaleRaw(languageCode);
  }
}
