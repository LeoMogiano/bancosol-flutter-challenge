import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/theme/app_theme.dart';
import 'package:warehouse/shared/widgets/layout/custom_scaffold.dart';

void main() {
  testWidgets('tocar fuera de un campo cierra el teclado en cualquier pantalla', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const CustomScaffold(body: Column(children: [TextField(), SizedBox(height: 300)])),
      ),
    );
    await tester.tap(find.byType(TextField));
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.tapAt(const Offset(200, 500));
    await tester.pump();

    expect(tester.testTextInput.isVisible, isFalse);
  });
}
