import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/app_theme.dart';
import 'package:warehouse/shared/widgets/inputs/custom_input.dart';

void main() {
  group('CustomInput', () {
    testWidgets('avisa onBlur al salir del campo (validación al perder foco)', (tester) async {
      tester.view.physicalSize = const Size(411 * 2.625, 891 * 2.625);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);

      var onBlurCalled = false;
      final secondFieldKey = GlobalKey();

      await tester.pumpWidget(
        Sizer(
          builder: (context, orientation, screenType) => MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: Column(
                children: [
                  CustomInput(
                    hintText: 'Nombre',
                    onBlur: () {
                      onBlurCalled = true;
                    },
                  ),
                  TextField(
                    key: secondFieldKey,
                    decoration: const InputDecoration(hintText: 'Otro campo'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(onBlurCalled, false);

      await tester.tap(find.byType(CustomInput));
      await tester.pump();

      expect(onBlurCalled, false);

      await tester.tap(find.byKey(secondFieldKey));
      await tester.pump();

      expect(onBlurCalled, true);
    });
  });
}
