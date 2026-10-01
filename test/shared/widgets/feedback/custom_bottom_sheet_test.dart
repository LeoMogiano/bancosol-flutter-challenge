import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/app_theme.dart';
import 'package:warehouse/shared/widgets/feedback/custom_bottom_sheet.dart';

void main() {
  group('CustomBottomSheet', () {
    testWidgets('con PopScope bloqueado el handle no cierra el sheet', (tester) async {
      tester.view.physicalSize = const Size(411 * 2.625, 891 * 2.625);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        Sizer(
          builder: (context, orientation, screenType) => MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: Center(
                child: Builder(
                  builder: (innerContext) => ElevatedButton(
                    onPressed: () {
                      unawaited(
                        CustomBottomSheet.show<void>(
                          innerContext,
                          PopScope(
                            canPop: false,
                            child: Container(
                              height: 300,
                              color: Colors.white,
                              child: const Center(child: Text('Sheet content')),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Open sheet'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open sheet'));
      await tester.pump();

      expect(find.text('Sheet content'), findsOneWidget);

      final handle = find.byType(GestureDetector).first;

      await tester.drag(handle, const Offset(0, 400));
      await tester.pump();

      expect(find.text('Sheet content'), findsOneWidget);
    });
  });
}
