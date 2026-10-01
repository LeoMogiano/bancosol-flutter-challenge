import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/app_theme.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/stock_indicator.dart';

void main() {
  setUp(() => LocaleSettings.setLocale(AppLocale.es));

  group('StockIndicator', () {
    testWidgets('el stock 0 se ve como Sin stock y 1–5 como stock bajo', (tester) async {
      tester.view.physicalSize = const Size(411 * 2.625, 891 * 2.625);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        Sizer(
          builder: (_, _, _) {
            return TranslationProvider(
              child: MaterialApp(
                theme: AppTheme.light,
                home: const Scaffold(body: Column(children: [StockIndicator(stock: 0), StockIndicator(stock: 3)])),
              ),
            );
          },
        ),
      );

      expect(find.text('Sin stock'), findsOneWidget);
      expect(find.text('3 en stock'), findsOneWidget);
    });
  });
}
