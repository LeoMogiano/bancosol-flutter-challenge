part of 'preferences_bloc.dart';

class PreferencesState extends Equatable {
  const PreferencesState({required this.themeMode, required this.locale, required this.cacheEnabled});

  factory PreferencesState.from(AppPreferences preferences) => PreferencesState(
    themeMode: ThemeMode.values.byName(preferences.themeMode.name),
    locale: preferences.language == null ? null : AppLocale.values.byName(preferences.language!.name),
    cacheEnabled: preferences.cacheEnabled,
  );

  final ThemeMode themeMode;

  // null = idioma del dispositivo.
  final AppLocale? locale;
  final bool cacheEnabled;

  PreferencesState copyWith({ThemeMode? themeMode, AppLocale? Function()? locale, bool? cacheEnabled}) {
    return PreferencesState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale != null ? locale() : this.locale,
      cacheEnabled: cacheEnabled ?? this.cacheEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, cacheEnabled];
}
