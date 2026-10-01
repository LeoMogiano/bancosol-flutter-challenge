import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/app_preferences.dart';
import 'package:warehouse/modules/catalog/domain/repositories/preferences_repository.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  PreferencesBloc(this._repository) : super(PreferencesState.from(_repository.load())) {
    on<PreferencesThemeModeChanged>(_onThemeModeChanged);
    on<PreferencesLanguageChanged>(_onLanguageChanged);
    on<PreferencesCacheToggled>(_onCacheToggled);
  }

  final PreferencesRepository _repository;

  Future<void> _onThemeModeChanged(PreferencesThemeModeChanged event, Emitter<PreferencesState> emit) async {
    emit(state.copyWith(themeMode: event.themeMode));
    await _repository.saveThemeMode(AppThemeMode.values.byName(event.themeMode.name));
  }

  Future<void> _onLanguageChanged(PreferencesLanguageChanged event, Emitter<PreferencesState> emit) async {
    emit(state.copyWith(languageCode: () => event.languageCode));
    await _repository.saveLanguage(event.languageCode);
  }

  Future<void> _onCacheToggled(PreferencesCacheToggled event, Emitter<PreferencesState> emit) async {
    emit(state.copyWith(cacheEnabled: event.enabled));
    await _repository.saveCacheEnabled(enabled: event.enabled);
  }
}
