import 'package:architecture_lab/core/device_label.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.shubhamtomar.architecture_lab/device_test');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('returns the host label when the channel responds', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'label');
          return 'Pixel test';
        });
    expect(await DeviceLabel.read(methodChannel: channel), 'Pixel test');
  });

  test('falls back when the host has no handler', () async {
    expect(
      await DeviceLabel.read(methodChannel: channel),
      defaultTargetPlatform.name,
    );
  });
}
