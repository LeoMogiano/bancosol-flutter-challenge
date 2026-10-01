import 'package:get_it/get_it.dart';
import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_cubit.dart';

abstract final class CatalogModule {
  static void registerDependencies(GetIt di) {
    di.registerLazySingleton<PreferencesCubit>(() => PreferencesCubit(di<LocalStore>()));
  }
}
