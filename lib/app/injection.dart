import 'package:warehouse/app/env_config.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/core/network/api_client.dart';
import 'package:warehouse/core/network/interceptors/api_key_interceptor.dart';
import 'package:warehouse/core/network/interceptors/redacting_log_interceptor.dart';
import 'package:warehouse/core/services/share_service.dart';
import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/core/utils/app_clock.dart';
import 'package:warehouse/modules/catalog/catalog_module.dart';

Future<void> injection() async {
  sl
    ..registerLazySingleton<LocalStore>(HiveLocalStore.new)
    ..registerLazySingleton<AppClock>(AppClock.new)
    ..registerLazySingleton<ShareService>(ShareService.new)
    ..registerLazySingleton<ApiKeyInterceptor>(() => ApiKeyInterceptor(EnvConfig.apiKey))
    ..registerLazySingleton<RedactingLogInterceptor>(RedactingLogInterceptor.new)
    ..registerLazySingleton<ApiClient>(
      () =>
          ApiClient(baseUrl: EnvConfig.baseUrl, interceptors: [sl<ApiKeyInterceptor>(), sl<RedactingLogInterceptor>()]),
    );

  CatalogModule.registerDependencies(sl);
}
