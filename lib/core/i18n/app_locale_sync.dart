import 'package:warehouse/core/i18n/strings.g.dart';

Future<void> applyAppLocale(AppLocale? locale) async {
  if (locale == null) {
    await LocaleSettings.useDeviceLocale();
  } else {
    await LocaleSettings.setLocale(locale);
  }
}
