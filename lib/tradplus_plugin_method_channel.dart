import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tradplus_plugin_platform_interface.dart';

/// An implementation of [TradplusPluginPlatform] that uses method channels.
class MethodChannelTradplusPlugin extends TradplusPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tradplus_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
