import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/app/app_bootstrap.dart';
import 'package:warehouse/app/precache_assets.dart';
import 'package:warehouse/app/router/app_router.dart';
import 'package:warehouse/app/sentry_config.dart';
import 'package:warehouse/app/state_provider.dart';
import 'package:warehouse/core/i18n/app_locale_sync.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/app_theme.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_bloc.dart';

Future<void> main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();
  await runWithSentry(() => bootstrap(MainApp.new));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StateProvider(
      child: BlocListener<PreferencesBloc, PreferencesState>(
        listenWhen: (prev, curr) => prev.languageCode != curr.languageCode,
        listener: (_, state) => applyAppLocale(state.languageCode),
        child: Sizer(
          builder: (_, _, _) => BlocSelector<PreferencesBloc, PreferencesState, ThemeMode>(
            selector: (state) => state.themeMode,
            builder: (context, themeMode) => MaterialApp.router(
              debugShowCheckedModeBanner: false,
              onGenerateTitle: (_) => t.appName,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeMode,
              locale: TranslationProvider.of(context).flutterLocale,
              supportedLocales: AppLocaleUtils.supportedLocales,
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              routerConfig: appRouter,
              builder: (_, child) => MediaQuery.withClampedTextScaling(
                minScaleFactor: 0.8,
                maxScaleFactor: 1.15,
                child: PrecacheAssets(child: child ?? const SizedBox.shrink()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
