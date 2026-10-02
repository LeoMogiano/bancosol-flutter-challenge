import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/i18n/generated/strings.g.dart';
import 'package:warehouse/core/theme/app_theme.dart';
import 'package:warehouse/modules/catalog/application/price_edit/price_edit_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/currency.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/update_product_price_use_case.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/price_edit_sheet.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';

class _MockUpdatePrice extends Mock implements UpdateProductPriceUseCase;

const _product = Product(
  remoteId: 'r1',
  id: 1,
  sku: 'SKU-1',
  name: 'Cuaderno',
  price: 100,
  currency: Currency.bob,
  stock: 4,
);

Future<void> _pump(WidgetTester tester, UpdateProductPriceUseCase updatePrice) async {
  tester.view
    ..physicalSize = const Size(411 * 2.625, 891 * 2.625)
    ..devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    TranslationProvider(
      child: Sizer(
        builder: (_, _, _) => MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: BlocProvider(
                create: (_) => PriceEditBloc(product: _product, updatePrice: updatePrice),
                child: const PriceEditContent(product: _product),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

AppButton _saveButton(WidgetTester tester, String label) =>
    tester.widget<AppButton>(find.widgetWithText(AppButton, label));

void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.es));

  testWidgets('con el mismo precio el botón Guardar está deshabilitado', (tester) async {
    await _pump(tester, _MockUpdatePrice());

    expect(find.text(t.validation.priceUnchanged), findsOneWidget);
    expect(_saveButton(tester, t.priceEdit.save).onPressed, isNull);
  });

  testWidgets('si el servidor falla aparece el aviso y el botón pasa a Reintentar', (tester) async {
    final updatePrice = _MockUpdatePrice();
    when(() => updatePrice(_product, 120)).thenThrow(const Failure(FailureType.server, statusCode: 500));
    await _pump(tester, updatePrice);

    await tester.enterText(find.byType(EditableText), '120');
    await tester.pump();
    await tester.tap(find.text(t.priceEdit.save));
    await tester.pumpAndSettle();

    expect(find.text(t.priceEdit.serverError), findsOneWidget);
    expect(_saveButton(tester, t.actions.retry).onPressed, isNotNull);
  });
}
