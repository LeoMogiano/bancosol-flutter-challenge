import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/services/logger_service.dart';
import 'package:warehouse/core/storage/local_store.dart';

part 'preferences_state.dart';

class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit(this._store)
    : super(
        PreferencesState(
          themeMode: ThemeMode.values.asNameMap()[_store.read<String>(SettingsKey.themeMode)] ?? ThemeMode.light,
          languageCode: _store.read<String>(SettingsKey.languageCode),
          cacheEnabled: _store.read<bool>(SettingsKey.cacheEnabled) ?? true,
        ),
      );

  final LocalStore _store;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    emit(state.copyWith(themeMode: themeMode));
    await _persist(SettingsKey.themeMode, themeMode.name);
  }

  Future<void> setLanguageCode(String? languageCode) async {
    emit(state.copyWith(languageCode: () => languageCode));
    await _persist(SettingsKey.languageCode, languageCode);
  }

  Future<void> setCacheEnabled({required bool enabled}) async {
    emit(state.copyWith(cacheEnabled: enabled));
    await _persist(SettingsKey.cacheEnabled, enabled);
  }

  // Si el disco falla, la preferencia vale para esta sesión; no tumba la UI.
  Future<void> _persist(SettingsKey key, Object? value) async {
    try {
      value == null ? await _store.delete(key) : await _store.write(key, value);
    } on Failure catch (f) {
      LoggerService.w('No se guardó ${key.id}: ${f.detail?.value}', name: 'PREFS');
    }
  }
}
