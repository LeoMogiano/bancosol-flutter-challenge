import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/app_theme.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';

void main() {
  group('AppButton', () {
    testWidgets('mientras carga muestra el texto alterno y no se puede tocar', (tester) async {
      tester.view.physicalSize = const Size(411 * 2.625, 891 * 2.625);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);

      var tapCount = 0;

      await tester.pumpWidget(
        Sizer(
          builder: (context, orientation, screenType) => MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: Center(
                child: AppButton(
                  label: 'Guardar',
                  loadingLabel: 'Guardando...',
                  loading: true,
                  onPressed: () => tapCount++,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Guardando...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Guardar'), findsNothing);

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(tapCount, 0);
    });
  });
}
