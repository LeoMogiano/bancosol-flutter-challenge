import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/theme/app_colors.dart';

void main() {
  test('al cambiar de tema los tokens saltan, no se interpolan', () {
    expect(AppColors.light.lerp(AppColors.dark, 0.49), AppColors.light);
    expect(AppColors.light.lerp(AppColors.dark, 0.5), AppColors.dark);
  });
}
