import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:warehouse/app/injection.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/core/network/api_client.dart';
import 'package:warehouse/core/network/interceptors/api_key_interceptor.dart';
import 'package:warehouse/core/network/interceptors/redacting_log_interceptor.dart';
import 'package:warehouse/core/storage/keys/store_box.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_bloc.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';
import 'package:warehouse/modules/catalog/domain/usecases/create_product_use_case.dart';
import 'package:warehouse/modules/catalog/domain/usecases/delete_product_use_case.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_product_use_case.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_products_use_case.dart';
import 'package:warehouse/modules/catalog/domain/usecases/share_product_use_case.dart';
import 'package:warehouse/modules/catalog/domain/usecases/update_product_price_use_case.dart';

// get_it registra fábricas perezosas: un cableado roto solo explota al resolver.
void main() {
  setUpAll(() async {
    Hive.init(Directory.systemTemp.createTempSync('warehouse_test').path);
    for (final box in StoreBox.values) {
      await Hive.openBox<dynamic>(box.id);
    }
    await injection();
  });

  test('todo el grafo de dependencias se resuelve sin errores', () {
    expect(sl.get<ApiClient>, returnsNormally);
    expect(sl.get<PreferencesBloc>, returnsNormally);
    expect(sl.get<ProductRepository>, returnsNormally);
    expect(sl.get<GetProductsUseCase>, returnsNormally);
    expect(sl.get<GetProductUseCase>, returnsNormally);
    expect(sl.get<UpdateProductPriceUseCase>, returnsNormally);
    expect(sl.get<CreateProductUseCase>, returnsNormally);
    expect(sl.get<DeleteProductUseCase>, returnsNormally);
    expect(sl.get<ShareProductUseCase>, returnsNormally);
  });

  test('los interceptores van en orden: api key → log', () {
    // dio instala su propio ImplyContentTypeInterceptor; se filtra antes de comparar.
    final types = sl<ApiClient>().dio.interceptors
        .map((i) => i.runtimeType)
        .where((t) => '$t' != 'ImplyContentTypeInterceptor')
        .toList();

    expect(types, [ApiKeyInterceptor, RedactingLogInterceptor]);
  });
}
