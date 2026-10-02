import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/app_theme.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/application/search_focus/search_focus_cubit.dart';
import 'package:warehouse/modules/catalog/domain/entities/currency.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/entities/products_snapshot.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_products_use_case.dart';
import 'package:warehouse/modules/catalog/presentation/screens/products_screen.dart';

class _MockGetProducts extends Mock implements GetProductsUseCase;

Future<void> _pumpScreen(
  WidgetTester tester, {
  required ProductsBloc bloc,
  required SearchFocusCubit focus,
  Widget child = const ProductsScreen(),
}) async {
  tester.view
    ..physicalSize = const Size(411 * 2.625, 891 * 2.625)
    ..devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    TranslationProvider(
      child: Sizer(
        builder: (_, _, _) => MaterialApp(
          theme: AppTheme.light,
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bloc),
              BlocProvider.value(value: focus),
            ],
            child: child,
          ),
        ),
      ),
    ),
  );
}

void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.es));

  testWidgets('si la API falla muestra el error y "Reintentar" vuelve a pedir el catálogo', (tester) async {
    final getProducts = _MockGetProducts();
    when(getProducts.call).thenThrow(const Failure(FailureType.network));
    final bloc = ProductsBloc(getProducts: getProducts)..add(const ProductsRequested());
    final focus = SearchFocusCubit();
    addTearDown(bloc.close);
    addTearDown(focus.close);

    await _pumpScreen(tester, bloc: bloc, focus: focus);
    await tester.pumpAndSettle();

    expect(find.text(t.products.errorTitle), findsOneWidget);
    await tester.tap(find.text(t.actions.retry));
    await tester.pumpAndSettle();

    verify(getProducts.call).called(2);
  });

  testWidgets('una búsqueda pedida antes de abrir Productos enfoca el campo al construirse', (tester) async {
    final bloc = ProductsBloc(getProducts: _MockGetProducts());
    final focus = SearchFocusCubit()..request();
    addTearDown(bloc.close);
    addTearDown(focus.close);

    await _pumpScreen(tester, bloc: bloc, focus: focus);
    await tester.pump();

    expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isTrue);
    expect(focus.state, isFalse);
  });

  testWidgets('con Productos ya montado en otra pestaña, pedir búsqueda al cambiar de pestaña enfoca el campo', (
    tester,
  ) async {
    final bloc = ProductsBloc(getProducts: _MockGetProducts());
    final focus = SearchFocusCubit();
    final tab = ValueNotifier(0);
    addTearDown(bloc.close);
    addTearDown(focus.close);
    addTearDown(tab.dispose);

    await _pumpScreen(
      tester,
      bloc: bloc,
      focus: focus,
      child: ValueListenableBuilder<int>(
        valueListenable: tab,
        builder: (_, index, _) => IndexedStack(index: index, children: const [SizedBox(), ProductsScreen()]),
      ),
    );

    tab.value = 1;
    focus.request();
    await tester.pump();
    await tester.pump();

    expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isTrue);
  });

  testWidgets('con el listado cargado, todo lo tocable tiene una etiqueta para el lector de pantalla', (tester) async {
    final semantics = tester.ensureSemantics();
    final getProducts = _MockGetProducts();
    final products = List.generate(
      12,
      (i) => Product(
        remoteId: 'r$i',
        id: i,
        sku: 'SKU-$i',
        name: 'Producto $i',
        price: 10,
        currency: Currency.bob,
        stock: 3,
      ),
    );
    when(getProducts.call).thenAnswer((_) async => ProductsSnapshot(products: products, syncedAt: DateTime(2026)));
    final bloc = ProductsBloc(getProducts: getProducts)..add(const ProductsRequested());
    final focus = SearchFocusCubit();
    addTearDown(bloc.close);
    addTearDown(focus.close);

    await _pumpScreen(tester, bloc: bloc, focus: focus);
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });
}
