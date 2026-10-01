import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_bloc.dart';

class _MockStore extends Mock implements LocalStore;

void main() {
  late _MockStore store;

  setUpAll(() => registerFallbackValue(SettingsKey.themeMode));

  setUp(() {
    store = _MockStore();
    when(() => store.read<String>(any())).thenReturn(null);
    when(() => store.read<bool>(any())).thenReturn(null);
    when(() => store.write(any(), any())).thenAnswer((_) async {});
    when(() => store.delete(any())).thenAnswer((_) async {});
  });

  test('al abrir la app restaura tema, idioma y cache guardados', () {
    when(() => store.read<String>(SettingsKey.themeMode)).thenReturn('dark');
    when(() => store.read<String>(SettingsKey.languageCode)).thenReturn('pt');
    when(() => store.read<bool>(SettingsKey.cacheEnabled)).thenReturn(false);

    final state = PreferencesBloc(store).state;

    expect(state.themeMode, ThemeMode.dark);
    expect(state.languageCode, 'pt');
    expect(state.cacheEnabled, isFalse);
  });

  test('volver al idioma del dispositivo borra la preferencia guardada', () async {
    final bloc = PreferencesBloc(store)..add(const PreferencesLanguageChanged(null));
    await pumpEventQueue();

    expect(bloc.state.languageCode, isNull);
    verify(() => store.delete(SettingsKey.languageCode)).called(1);
  });
}
