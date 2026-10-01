import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/app/env_config.dart';
import 'package:warehouse/core/constants/app_assets.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_cubit.dart';
import 'package:warehouse/shared/widgets/layout/custom_scaffold.dart';

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  static const double _logoSize = 96;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    return CustomScaffold(
      scrollable: true,
      body: Column(
        children: [
          const SizedBox(height: 32),
          Image.asset(AppAssets.logo, width: _logoSize, height: _logoSize),
          const SizedBox(height: 20),
          Text(
            t.appName.toUpperCase(),
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, letterSpacing: 1.7, color: colors.ink3),
          ),
          const SizedBox(height: 8),
          Text(
            t.appName,
            style: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 22.65.sp, height: 1.05, color: colors.ink),
          ),
          const SizedBox(height: 16),
          Text(
            t.environmentLabel(env: EnvConfig.env.name.toUpperCase()),
            style: TextStyle(fontSize: 15.sp, color: colors.ink2),
          ),
          const SizedBox(height: 24),
          BlocSelector<PreferencesCubit, PreferencesState, ThemeMode>(
            selector: (state) => state.themeMode,
            builder: (context, themeMode) => SegmentedButton<ThemeMode>(
              selected: {themeMode},
              onSelectionChanged: (modes) => context.read<PreferencesCubit>().setThemeMode(modes.first),
              segments: [
                ButtonSegment(value: ThemeMode.light, label: Text(t.theme.light)),
                ButtonSegment(value: ThemeMode.dark, label: Text(t.theme.dark)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          BlocSelector<PreferencesCubit, PreferencesState, String>(
            selector: (state) => state.languageCode ?? TranslationProvider.of(context).locale.languageCode,
            builder: (context, languageCode) => SegmentedButton<String>(
              selected: {languageCode},
              onSelectionChanged: (codes) => context.read<PreferencesCubit>().setLanguageCode(codes.first),
              segments: const [
                ButtonSegment(value: 'es', label: Text('Español')),
                ButtonSegment(value: 'en', label: Text('English')),
                ButtonSegment(value: 'pt', label: Text('Português')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
