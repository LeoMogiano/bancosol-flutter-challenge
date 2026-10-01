import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/services/logger_service.dart';
import 'package:warehouse/core/storage/keys/settings_key.dart';
import 'package:warehouse/core/storage/local_store.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  PreferencesBloc(this._store)
    : super(
        PreferencesState(
          themeMode: ThemeMode.values.asNameMap()[_store.read<String>(SettingsKey.themeMode)] ?? ThemeMode.light,
          languageCode: _store.read<String>(SettingsKey.languageCode),
          cacheEnabled: _store.read<bool>(SettingsKey.cacheEnabled) ?? true,
        ),
      ) {
    on<PreferencesThemeModeChanged>(_onThemeModeChanged);
    on<PreferencesLanguageChanged>(_onLanguageChanged);
    on<PreferencesCacheToggled>(_onCacheToggled);
  }

  final LocalStore _store;

  Future<void> _onThemeModeChanged(PreferencesThemeModeChanged event, Emitter<PreferencesState> emit) async {
    emit(state.copyWith(themeMode: event.themeMode));
    await _persist(SettingsKey.themeMode, event.themeMode.name);
  }

  Future<void> _onLanguageChanged(PreferencesLanguageChanged event, Emitter<PreferencesState> emit) async {
    emit(state.copyWith(languageCode: () => event.languageCode));
    await _persist(SettingsKey.languageCode, event.languageCode);
  }

  Future<void> _onCacheToggled(PreferencesCacheToggled event, Emitter<PreferencesState> emit) async {
    emit(state.copyWith(cacheEnabled: event.enabled));
    await _persist(SettingsKey.cacheEnabled, event.enabled);
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
