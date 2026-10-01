import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/app_theme.dart';
import 'package:warehouse/shared/widgets/navigation/app_paginator.dart';

void main() {
  group('AppPaginator', () {
    testWidgets('con muchas páginas muestra 1 … actual … última', (tester) async {
      tester.view.physicalSize = const Size(411 * 2.625, 891 * 2.625);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);

      var selectedPage = 5;

      await tester.pumpWidget(
        Sizer(
          builder: (context, orientation, screenType) => MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: Center(
                child: AppPaginator(
                  page: selectedPage,
                  pageCount: 10,
                  onChanged: (page) {
                    selectedPage = page;
                  },
                  pageLabel: (n) => 'Página $n',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('1'), findsWidgets);
      expect(find.text('10'), findsWidgets);
      expect(find.text('5'), findsWidgets);

      expect(find.text('4'), findsWidgets);
      expect(find.text('6'), findsWidgets);

      expect(find.text('…'), findsWidgets);
    });
  });
}
