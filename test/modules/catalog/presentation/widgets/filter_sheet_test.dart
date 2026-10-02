import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/generated/strings.g.dart';
import 'package:warehouse/core/theme/app_theme.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/currency.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/filter_sheet.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_avatar.dart';

Product _product(int id, {required int stock, String name = 'Item'}) =>
    Product(remoteId: '$id', id: id, sku: 'SKU-$id', name: name, price: 10, currency: Currency.bob, stock: stock);

Future<void> _pump(WidgetTester tester, Widget home) async {
  tester.view
    ..physicalSize = const Size(411 * 2.625, 891 * 2.625)
    ..devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    TranslationProvider(
      child: Sizer(
        builder: (_, _, _) => MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(body: home),
        ),
      ),
    ),
  );
}

void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.es));

  testWidgets('"Ver N productos" cuenta en vivo antes de aplicar el filtro', (tester) async {
    final all = [_product(1, stock: 3), _product(2, stock: 0), _product(3, stock: 9)];
    await _pump(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => FilterSheet.open(
            context,
            state: ProductsState(all: all, visible: all),
          ),
          child: const Text('abrir'),
        ),
      ),
    );

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text(t.filters.apply(n: 3)), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.text(t.filters.apply(n: 2)), findsOneWidget);
  });

  testWidgets('un producto sin nombre muestra "?" en vez de romper la lista', (tester) async {
    await _pump(tester, ProductAvatar(product: _product(1, stock: 1, name: '  ')));

    expect(find.text('?'), findsOneWidget);
  });
}
