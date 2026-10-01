import 'package:equatable/equatable.dart';

enum AppThemeMode { light, dark, system }

class AppPreferences extends Equatable {
  const AppPreferences({this.themeMode = AppThemeMode.light, this.languageCode, this.cacheEnabled = true});

  final AppThemeMode themeMode;

  // null = idioma del dispositivo.
  final String? languageCode;
  final bool cacheEnabled;

  AppPreferences copyWith({AppThemeMode? themeMode, String? Function()? languageCode, bool? cacheEnabled}) {
    return AppPreferences(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode != null ? languageCode() : this.languageCode,
      cacheEnabled: cacheEnabled ?? this.cacheEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, languageCode, cacheEnabled];
}
