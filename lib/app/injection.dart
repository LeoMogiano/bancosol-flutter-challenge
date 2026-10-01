import 'package:warehouse/app/env_config.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/core/network/api_client.dart';
import 'package:warehouse/core/network/interceptors/api_key_interceptor.dart';
import 'package:warehouse/core/network/interceptors/redacting_log_interceptor.dart';
import 'package:warehouse/core/network/interceptors/retry_interceptor.dart';
import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/core/utils/app_clock.dart';
import 'package:warehouse/modules/catalog/catalog_module.dart';

Future<void> injection() async {
  sl
    // 1️⃣ Almacenamiento
    ..registerLazySingleton<LocalStore>(HiveLocalStore.new)
    // 2️⃣ Servicios de core
    ..registerLazySingleton<AppClock>(AppClock.new)
    // 3️⃣ Interceptores de red
    ..registerLazySingleton<ApiKeyInterceptor>(() => ApiKeyInterceptor(EnvConfig.apiKey))
    ..registerLazySingleton<RetryInterceptor>(RetryInterceptor.new)
    ..registerLazySingleton<RedactingLogInterceptor>(RedactingLogInterceptor.new)
    // 4️⃣ Red
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(
        baseUrl: EnvConfig.baseUrl,
        interceptors: [sl<ApiKeyInterceptor>(), sl<RetryInterceptor>(), sl<RedactingLogInterceptor>()],
      ),
    );

  CatalogModule.registerDependencies(sl);
}
