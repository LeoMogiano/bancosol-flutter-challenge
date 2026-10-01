import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/app_theme.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_products.dart';
import 'package:warehouse/modules/catalog/presentation/screens/products_screen.dart';
import 'package:warehouse/modules/catalog/presentation/shell/main_shell.dart';

class _MockGetProducts extends Mock implements GetProducts;

void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.es));

  testWidgets('si la API falla muestra el error y "Reintentar" vuelve a pedir el catálogo', (tester) async {
    tester.view
      ..physicalSize = const Size(411 * 2.625, 891 * 2.625)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final getProducts = _MockGetProducts();
    when(() => getProducts(useCache: true)).thenThrow(const Failure(FailureType.network));
    final bloc = ProductsBloc(getProducts: getProducts, useCache: () => true)..add(const ProductsRequested());
    addTearDown(bloc.close);

    await tester.pumpWidget(
      TranslationProvider(
        child: Sizer(
          builder: (_, _, _) => MaterialApp(
            theme: AppTheme.light,
            home: RepositoryProvider(
              create: (_) => SearchFocusRequest(),
              child: BlocProvider.value(value: bloc, child: const ProductsScreen()),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(t.products.errorTitle), findsOneWidget);
    await tester.tap(find.text(t.actions.retry));
    await tester.pumpAndSettle();

    verify(() => getProducts(useCache: true)).called(2);
  });
}
