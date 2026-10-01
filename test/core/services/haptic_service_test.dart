import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/services/haptic_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final system = <MethodCall>[];
  final android = <MethodCall>[];

  setUp(() {
    system.clear();
    android.clear();
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      ..setMockMethodCallHandler(SystemChannels.platform, (call) async => system.add(call))
      ..setMockMethodCallHandler(const MethodChannel('app/haptics'), (call) async => android.add(call));
    addTearDown(
      () => messenger
        ..setMockMethodCallHandler(SystemChannels.platform, null)
        ..setMockMethodCallHandler(const MethodChannel('app/haptics'), null),
    );
  });

  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('iOS usa el haptic del sistema y Android delega al canal nativo', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    HapticService.success();
    expect(system.single.arguments, 'HapticFeedbackType.successNotification');
    expect(android, isEmpty);

    system.clear();
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    HapticService.success();
    expect(android.single.arguments, 'success');
    expect(system, isEmpty);
  });
}
