part of 'preferences_cubit.dart';

class PreferencesState extends Equatable {
  const PreferencesState({required this.themeMode, required this.languageCode, required this.cacheEnabled});

  final ThemeMode themeMode;

  // null = idioma del dispositivo.
  final String? languageCode;
  final bool cacheEnabled;

  PreferencesState copyWith({ThemeMode? themeMode, String? Function()? languageCode, bool? cacheEnabled}) {
    return PreferencesState(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode != null ? languageCode() : this.languageCode,
      cacheEnabled: cacheEnabled ?? this.cacheEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, languageCode, cacheEnabled];
}
