import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/failure_i18n.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_cubit.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/shared/widgets/cards/app_card.dart';
import 'package:warehouse/shared/widgets/feedback/app_toast.dart';
import 'package:warehouse/shared/widgets/inputs/app_segmented.dart';
import 'package:warehouse/shared/widgets/layout/app_top_bar.dart';
import 'package:warehouse/shared/widgets/layout/custom_scaffold.dart';
import 'package:warehouse/shared/widgets/lists/app_switch_tile.dart';
import 'package:warehouse/shared/widgets/lists/app_tile.dart';

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
            // 130: holgura para que la barra de navegación flotante no tape la última sección.
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Section(title: t.settings.appearance, child: const _ThemeSelector()),
                _Section(title: t.settings.language, child: const _LanguageSelector()),
                _Section(title: t.settings.data, child: const _DataCard()),
                _Section(title: t.settings.about, child: const _VersionCard()),
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
    return BlocSelector<PreferencesCubit, PreferencesState, ThemeMode>(
      selector: (state) => state.themeMode,
      builder: (context, themeMode) => AppSegmented<ThemeMode>(
        // "Sistema" no está en el diseño: el modo efectivo del dispositivo se muestra como Claro u Oscuro.
        selected: themeMode == ThemeMode.system ? (context.isDarkMode ? ThemeMode.dark : ThemeMode.light) : themeMode,
        onChanged: context.read<PreferencesCubit>().setThemeMode,
        segments: [
          AppSegment(value: ThemeMode.light, label: t.theme.light, icon: Icons.light_mode_rounded),
          AppSegment(value: ThemeMode.dark, label: t.theme.dark, icon: Icons.dark_mode_rounded),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return BlocSelector<PreferencesCubit, PreferencesState, String?>(
      selector: (state) => state.languageCode,
      builder: (context, languageCode) => AppSegmented<String?>(
        selected: languageCode,
        onChanged: context.read<PreferencesCubit>().setLanguageCode,
        segments: [
          AppSegment(value: null, label: t.settings.deviceLanguage),
          const AppSegment(value: 'es', label: 'ES'),
          const AppSegment(value: 'en', label: 'EN'),
          const AppSegment(value: 'pt', label: 'PT'),
        ],
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  const _DataCard();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          BlocSelector<PreferencesCubit, PreferencesState, bool>(
            selector: (state) => state.cacheEnabled,
            builder: (context, enabled) => AppSwitchTile(
              icon: Icons.offline_bolt_outlined,
              title: t.settings.cache,
              subtitle: t.settings.cacheHint,
              value: enabled,
              onChanged: (value) => context.read<PreferencesCubit>().setCacheEnabled(enabled: value),
            ),
          ),
          Divider(height: 1, color: colors.line),
          BlocSelector<ProductsBloc, ProductsState, ({DateTime? syncedAt, bool refreshing})>(
            selector: (state) => (syncedAt: state.syncedAt, refreshing: state.isRefreshing),
            builder: (context, data) => AppTile(
              icon: Icons.sync_rounded,
              title: t.settings.syncNow,
              subtitle: data.syncedAt == null
                  ? t.settings.neverSynced
                  : t.settings.syncedAt(time: DateFormat.Hm().format(data.syncedAt!)),
              onTap: data.refreshing ? null : () => _sync(context),
              trailing: data.refreshing
                  ? SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: colors.accent),
                    )
                  : Icon(Icons.chevron_right_rounded, color: colors.ink3),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sync(BuildContext context) async {
    final t = context.t;
    final bloc = context.read<ProductsBloc>()..add(const ProductsRefreshed());
    final state = await bloc.stream.firstWhere((s) => !s.isRefreshing);
    if (!context.mounted) return;
    final failure = state.failure;
    failure == null
        ? AppToast.show(context, t.toasts.synced)
        : AppToast.show(context, failure.message, icon: Icons.error_rounded);
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
