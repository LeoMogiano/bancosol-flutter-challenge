import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:warehouse/app/injection.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/core/network/api_client.dart';
import 'package:warehouse/core/network/interceptors/api_key_interceptor.dart';
import 'package:warehouse/core/network/interceptors/redacting_log_interceptor.dart';
import 'package:warehouse/core/network/interceptors/retry_interceptor.dart';
import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_cubit.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';
import 'package:warehouse/modules/catalog/domain/usecases/create_product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/delete_product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_products.dart';
import 'package:warehouse/modules/catalog/domain/usecases/share_product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/update_product_price.dart';

// get_it registra fábricas perezosas: un cableado roto solo explota al resolver.
void main() {
  setUpAll(() async {
    Hive.init(Directory.systemTemp.createTempSync('warehouse_test').path);
    for (final box in StoreBox.all) {
      await Hive.openBox<dynamic>(box);
    }
    await injection();
  });

  test('todo el grafo de dependencias se resuelve sin errores', () {
    expect(sl.get<ApiClient>, returnsNormally);
    expect(sl.get<PreferencesCubit>, returnsNormally);
    expect(sl.get<ProductRepository>, returnsNormally);
    expect(sl.get<GetProducts>, returnsNormally);
    expect(sl.get<GetProduct>, returnsNormally);
    expect(sl.get<UpdateProductPrice>, returnsNormally);
    expect(sl.get<CreateProduct>, returnsNormally);
    expect(sl.get<DeleteProduct>, returnsNormally);
    expect(sl.get<ShareProduct>, returnsNormally);
  });

  test('los interceptores van en orden: api key → retry → log', () {
    // dio instala su propio ImplyContentTypeInterceptor; se filtra antes de comparar.
    final types = sl<ApiClient>().dio.interceptors
        .map((i) => i.runtimeType)
        .where((t) => '$t' != 'ImplyContentTypeInterceptor')
        .toList();

    expect(types, [ApiKeyInterceptor, RetryInterceptor, RedactingLogInterceptor]);
  });
}
