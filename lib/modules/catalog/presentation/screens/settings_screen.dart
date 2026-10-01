import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/app/env_config.dart';
import 'package:warehouse/core/constants/app_assets.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_bloc.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/settings/data_card.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/settings/sentry_test_card.dart';
import 'package:warehouse/shared/widgets/cards/app_card.dart';
import 'package:warehouse/shared/widgets/inputs/app_segmented.dart';
import 'package:warehouse/shared/widgets/layout/app_top_bar.dart';
import 'package:warehouse/shared/widgets/layout/custom_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return CustomScaffold(
      scrollable: true,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTopBar.large(eyebrow: t.settings.eyebrow, title: t.settings.title),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Section(title: t.settings.appearance, child: const _ThemeSelector()),
                _Section(title: t.settings.language, child: const _LanguageSelector()),
                _Section(title: t.settings.data, child: const DataCard()),
                _Section(title: t.settings.about, child: const _VersionCard()),
                if (!EnvConfig.isProd) _Section(title: t.settings.diagnostics, child: const SentryTestCard()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: context.colors.ink2),
          ),
          child,
        ],
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final themeMode = context.select<PreferencesBloc, ThemeMode>((bloc) => bloc.state.themeMode);
    return AppSegmented<ThemeMode>(
      // "Sistema" no está en el diseño: el modo efectivo del dispositivo se muestra como Claro u Oscuro.
      selected: themeMode == ThemeMode.system ? (context.isDarkMode ? ThemeMode.dark : ThemeMode.light) : themeMode,
      onChanged: (mode) => context.read<PreferencesBloc>().add(PreferencesThemeModeChanged(mode)),
      segments: [
        AppSegment(value: ThemeMode.light, label: t.theme.light, icon: Icons.light_mode_rounded),
        AppSegment(value: ThemeMode.dark, label: t.theme.dark, icon: Icons.dark_mode_rounded),
      ],
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final languageCode = context.select<PreferencesBloc, String?>((bloc) => bloc.state.languageCode);
    return AppSegmented<String?>(
      selected: languageCode,
      onChanged: (code) => context.read<PreferencesBloc>().add(PreferencesLanguageChanged(code)),
      segments: [
        AppSegment(value: null, label: t.settings.deviceLanguage),
        const AppSegment(value: 'es', label: 'ES', leading: _Flag(AppAssets.flagBolivia)),
        const AppSegment(value: 'en', label: 'EN', leading: _Flag(AppAssets.flagUnitedStates)),
        const AppSegment(value: 'pt', label: 'PT', leading: _Flag(AppAssets.flagBrazil)),
      ],
    );
  }
}

class _Flag extends StatelessWidget {
  const _Flag(this.asset);

  static const double _size = 18;

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(asset, width: _size, height: _size, excludeFromSemantics: true);
  }
}

class _VersionCard extends StatelessWidget {
  const _VersionCard();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Text(
              t.settings.version,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: colors.ink),
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (_, snapshot) {
              final info = snapshot.data;
              return Text(
                info == null ? '' : '${info.version} (${info.buildNumber})',
                style: TextStyle(fontSize: 15.sp, color: colors.ink2),
              );
            },
          ),
        ],
      ),
    );
  }
}
