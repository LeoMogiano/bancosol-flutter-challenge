part of 'preferences_bloc.dart';

sealed class PreferencesEvent extends Equatable {
  const PreferencesEvent();

  @override
  List<Object?> get props => [];
}

final class PreferencesThemeModeChanged extends PreferencesEvent {
  const PreferencesThemeModeChanged(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

// null = idioma del dispositivo.
final class PreferencesLanguageChanged extends PreferencesEvent {
  const PreferencesLanguageChanged(this.locale);

  final AppLocale? locale;

  @override
  List<Object?> get props => [locale];
}

final class PreferencesCacheToggled extends PreferencesEvent {
  const PreferencesCacheToggled({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}
