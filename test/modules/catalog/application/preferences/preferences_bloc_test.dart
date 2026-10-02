import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/app_preferences.dart';
import 'package:warehouse/modules/catalog/domain/repositories/preferences_repository.dart';

class _MockRepository extends Mock implements PreferencesRepository;

void main() {
  test('al abrir la app restaura tema, idioma y cache guardados', () {
    final repository = _MockRepository();
    when(repository.load)
        .thenReturn(const AppPreferences(themeMode: AppThemeMode.dark, language: AppLanguage.pt, cacheEnabled: false));

    final state = PreferencesBloc(repository).state;

    expect(state.themeMode, ThemeMode.dark);
    expect(state.locale, AppLocale.pt);
    expect(state.cacheEnabled, isFalse);
  });
}
