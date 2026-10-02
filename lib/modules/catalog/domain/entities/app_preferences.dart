import 'package:equatable/equatable.dart';

enum AppThemeMode { light, dark, system }

enum AppLanguage { es, en, pt }

class AppPreferences extends Equatable {
  const AppPreferences({this.themeMode = AppThemeMode.light, this.language, this.cacheEnabled = true});

  final AppThemeMode themeMode;

  // null = idioma del dispositivo.
  final AppLanguage? language;
  final bool cacheEnabled;

  AppPreferences copyWith({AppThemeMode? themeMode, AppLanguage? Function()? language, bool? cacheEnabled}) {
    return AppPreferences(
      themeMode: themeMode ?? this.themeMode,
      language: language != null ? language() : this.language,
      cacheEnabled: cacheEnabled ?? this.cacheEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, language, cacheEnabled];
}
