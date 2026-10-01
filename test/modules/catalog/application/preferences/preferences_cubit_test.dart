import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_cubit.dart';

class _MockStore extends Mock implements LocalStore;

void main() {
  late _MockStore store;

  setUp(() {
    store = _MockStore();
    when(() => store.read<String>(any(), any())).thenReturn(null);
    when(() => store.read<bool>(any(), any())).thenReturn(null);
    when(() => store.write(any(), any(), any())).thenAnswer((_) async {});
    when(() => store.delete(any(), any())).thenAnswer((_) async {});
  });

  test('al abrir la app restaura tema, idioma y cache guardados', () {
    when(() => store.read<String>(StoreBox.settings, 'theme_mode')).thenReturn('dark');
    when(() => store.read<String>(StoreBox.settings, 'locale')).thenReturn('pt');
    when(() => store.read<bool>(StoreBox.settings, 'cache_enabled')).thenReturn(false);

    final state = PreferencesCubit(store).state;

    expect(state.themeMode, ThemeMode.dark);
    expect(state.languageCode, 'pt');
    expect(state.cacheEnabled, isFalse);
  });

  test('volver al idioma del dispositivo borra la preferencia guardada', () async {
    final cubit = PreferencesCubit(store);

    await cubit.setLanguageCode(null);

    expect(cubit.state.languageCode, isNull);
    verify(() => store.delete(StoreBox.settings, 'locale')).called(1);
  });
}
