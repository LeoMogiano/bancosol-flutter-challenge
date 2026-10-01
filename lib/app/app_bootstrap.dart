import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:warehouse/app/injection.dart';
import 'package:warehouse/core/config/env_config.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/core/i18n/app_locale_sync.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/storage/local_store.dart';
// import 'package:warehouse/core/utils/app_bloc_observer.dart';
import 'package:warehouse/core/utils/logger_service.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_bloc.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';

Future<void> bootstrap(Widget Function() builder) async {
  final emoji = switch (EnvConfig.env) {
    Environment.prod => '🔥',
    Environment.qa => '🧪',
    Environment.dev => '🐛',
  };
  LoggerService.i('$emoji Booting ${EnvConfig.env.name}', name: 'BOOT');
  EnvConfig.validate();
  // Android < 15 no es edge-to-edge por defecto: la nav bar transparente se ve negra.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Bloc.observer = AppBlocObserver();
  await HiveLocalStore.init();
  await injection();
  await applyAppLocale(sl<PreferencesBloc>().state.languageCode);
  sl<ProductsBloc>().add(const ProductsRequested());

  LoggerService.s('App ready', name: 'BOOT');
  runApp(
    SentryWidget(
      child: SentryUserInteractionWidget(child: TranslationProvider(child: builder())),
    ),
  );
}
