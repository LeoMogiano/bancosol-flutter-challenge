import 'package:get_it/get_it.dart';
import 'package:warehouse/core/network/api_client.dart';
import 'package:warehouse/core/services/share_service.dart';
import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/core/utils/app_clock.dart';
import 'package:warehouse/modules/catalog/application/delete_product/delete_product_bloc.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_bloc.dart';
import 'package:warehouse/modules/catalog/application/price_edit/price_edit_bloc.dart';
import 'package:warehouse/modules/catalog/application/product_detail/product_detail_bloc.dart';
import 'package:warehouse/modules/catalog/application/product_form/product_form_bloc.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/data/datasources/product_local_data_source.dart';
import 'package:warehouse/modules/catalog/data/datasources/product_remote_data_source.dart';
import 'package:warehouse/modules/catalog/data/repositories/preferences_repository_impl.dart';
import 'package:warehouse/modules/catalog/data/repositories/product_repository_impl.dart';
import 'package:warehouse/modules/catalog/data/repositories/share_repository_impl.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/repositories/preferences_repository.dart';
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
      // Data sources
      ..registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSource(di<ApiClient>()))
      ..registerLazySingleton<ProductLocalDataSource>(() => ProductLocalDataSource(di<LocalStore>()))
      // Repositories
      ..registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(remote: di<ProductRemoteDataSource>(), local: di<ProductLocalDataSource>()),
      )
      ..registerLazySingleton<PreferencesRepository>(() => PreferencesRepositoryImpl(di<LocalStore>()))
      ..registerLazySingleton<ShareRepository>(() => ShareRepositoryImpl(di<ShareService>()))
      // Use cases
      ..registerLazySingleton<GetProductsUseCase>(
        () => GetProductsUseCase(di<ProductRepository>(), di<PreferencesRepository>()),
      )
      ..registerLazySingleton<GetProductUseCase>(() => GetProductUseCase(di<ProductRepository>()))
      ..registerLazySingleton<CreateProductUseCase>(() => CreateProductUseCase(di<ProductRepository>()))
      ..registerLazySingleton<UpdateProductPriceUseCase>(() => UpdateProductPriceUseCase(di<ProductRepository>()))
      ..registerLazySingleton<DeleteProductUseCase>(() => DeleteProductUseCase(di<ProductRepository>()))
      ..registerLazySingleton<ShareProductUseCase>(() => ShareProductUseCase(di<ShareRepository>()))
      // Blocs
      ..registerLazySingleton<PreferencesBloc>(() => PreferencesBloc(di<PreferencesRepository>()))
      ..registerLazySingleton<ProductsBloc>(
        () => ProductsBloc(getProducts: di<GetProductsUseCase>(), clock: di<AppClock>()),
      )
      ..registerFactory<ProductDetailBloc>(() => ProductDetailBloc(shareProduct: di<ShareProductUseCase>()))
      ..registerFactoryParam<ProductFormBloc, List<Product>, void>(
        (existing, _) => ProductFormBloc(existing: existing, createProduct: di<CreateProductUseCase>()),
      )
      ..registerFactoryParam<PriceEditBloc, Product, void>(
        (product, _) => PriceEditBloc(product: product, updatePrice: di<UpdateProductPriceUseCase>()),
      )
      ..registerFactoryParam<DeleteProductBloc, Product, void>(
        (product, _) => DeleteProductBloc(product: product, deleteProduct: di<DeleteProductUseCase>()),
      );
  }
}
