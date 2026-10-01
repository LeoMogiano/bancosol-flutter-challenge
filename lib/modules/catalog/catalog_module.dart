import 'package:get_it/get_it.dart';
import 'package:warehouse/core/network/api_client.dart';
import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/core/utils/app_clock.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_cubit.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/data/datasources/product_local_data_source.dart';
import 'package:warehouse/modules/catalog/data/datasources/product_remote_data_source.dart';
import 'package:warehouse/modules/catalog/data/repositories/product_repository_impl.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';
import 'package:warehouse/modules/catalog/domain/usecases/create_product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/delete_product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_products.dart';
import 'package:warehouse/modules/catalog/domain/usecases/update_product_price.dart';

abstract final class CatalogModule {
  static void registerDependencies(GetIt di) {
    di
      ..registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSource(di<ApiClient>()))
      ..registerLazySingleton<ProductLocalDataSource>(() => ProductLocalDataSource(di<LocalStore>()))
      ..registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(remote: di<ProductRemoteDataSource>(), local: di<ProductLocalDataSource>()),
      )
      ..registerLazySingleton<GetProducts>(() => GetProducts(di<ProductRepository>()))
      ..registerLazySingleton<GetProduct>(() => GetProduct(di<ProductRepository>()))
      ..registerLazySingleton<UpdateProductPrice>(() => UpdateProductPrice(di<ProductRepository>()))
      ..registerLazySingleton<CreateProduct>(() => CreateProduct(di<ProductRepository>()))
      ..registerLazySingleton<DeleteProduct>(() => DeleteProduct(di<ProductRepository>()))
      ..registerLazySingleton<PreferencesCubit>(() => PreferencesCubit(di<LocalStore>()))
      // Singleton: Resumen, Productos y Ajustes comparten el mismo catálogo en memoria.
      ..registerLazySingleton<ProductsBloc>(
        () => ProductsBloc(
          getProducts: di<GetProducts>(),
          useCache: () => di<PreferencesCubit>().state.cacheEnabled,
          clock: di<AppClock>(),
        ),
      );
  }
}
