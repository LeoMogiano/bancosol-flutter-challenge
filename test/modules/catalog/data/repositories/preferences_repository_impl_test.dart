import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/storage/keys/settings_key.dart';
import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/modules/catalog/data/repositories/preferences_repository_impl.dart';

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

  test('volver al idioma del dispositivo borra la preferencia guardada', () async {
    await PreferencesRepositoryImpl(store).saveLanguage(null);

    verify(() => store.delete(SettingsKey.languageCode)).called(1);
  });

  test('si el disco falla, la preferencia igual vale para esta sesión', () async {
    when(() => store.write(any(), any())).thenThrow(const Failure(FailureType.cache));
    final repository = PreferencesRepositoryImpl(store);

    await repository.saveCacheEnabled(enabled: false);

    expect(repository.load().cacheEnabled, isFalse);
  });
}
