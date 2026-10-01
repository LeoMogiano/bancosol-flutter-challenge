import 'package:get_it/get_it.dart';
import 'package:warehouse/core/network/api_client.dart';
import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/core/utils/app_clock.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_cubit.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/data/datasources/product_local_data_source.dart';
import 'package:warehouse/modules/catalog/data/datasources/product_remote_data_source.dart';
import 'package:warehouse/modules/catalog/data/datasources/share_channel.dart';
import 'package:warehouse/modules/catalog/data/repositories/product_repository_impl.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';
import 'package:warehouse/modules/catalog/domain/repositories/share_repository.dart';
import 'package:warehouse/modules/catalog/domain/usecases/create_product_use_case.dart';
import 'package:warehouse/modules/catalog/domain/usecases/delete_product_use_case.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_product_use_case.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_products_use_case.dart';
import 'package:warehouse/modules/catalog/domain/usecases/share_product_use_case.dart';
import 'package:warehouse/modules/catalog/domain/usecases/update_product_price_use_case.dart';

abstract final class CatalogModule {
  static void registerDependencies(GetIt di) {
    di
      ..registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSource(di<ApiClient>()))
      ..registerLazySingleton<ProductLocalDataSource>(() => ProductLocalDataSource(di<LocalStore>()))
      ..registerLazySingleton<ShareRepository>(ShareChannel.new)
      ..registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(remote: di<ProductRemoteDataSource>(), local: di<ProductLocalDataSource>()),
      )
      ..registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(di<ProductRepository>()))
      ..registerLazySingleton<GetProductUseCase>(() => GetProductUseCase(di<ProductRepository>()))
      ..registerLazySingleton<UpdateProductPriceUseCase>(() => UpdateProductPriceUseCase(di<ProductRepository>()))
      ..registerLazySingleton<CreateProductUseCase>(() => CreateProductUseCase(di<ProductRepository>()))
      ..registerLazySingleton<DeleteProductUseCase>(() => DeleteProductUseCase(di<ProductRepository>()))
      ..registerLazySingleton<ShareProductUseCase>(() => ShareProductUseCase(di<ShareRepository>()))
      ..registerLazySingleton<PreferencesCubit>(() => PreferencesCubit(di<LocalStore>()))
      // Singleton: Resumen, Productos y Ajustes comparten el mismo catálogo en memoria.
      ..registerLazySingleton<ProductsBloc>(
        () => ProductsBloc(
          getProducts: di<GetProductsUseCase>(),
          useCache: () => di<PreferencesCubit>().state.cacheEnabled,
          clock: di<AppClock>(),
        ),
      );
  }
}
