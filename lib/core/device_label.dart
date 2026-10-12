import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Reads a label from the host platform.
///
/// Android and iOS implement `label` on this channel. Widget tests and any
/// target without a handler fall back to [defaultTargetPlatform].
class DeviceLabel {
  static const channel = MethodChannel(
    'com.shubhamtomar.architecture_lab/device',
  );

  static Future<String> read({MethodChannel? methodChannel}) async {
    final active = methodChannel ?? channel;
    try {
      final value = await active.invokeMethod<String>('label');
      if (value != null && value.isNotEmpty) {
        return value;
      }
    } on MissingPluginException {
      // The host did not register the channel.
    } on PlatformException {
      // The host rejected the call.
    }
    return defaultTargetPlatform.name;
  }
}
