import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tradplus_plugin_method_channel.dart';

abstract class TradplusPluginPlatform extends PlatformInterface {
  /// Constructs a TradplusPluginPlatform.
  TradplusPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static TradplusPluginPlatform _instance = MethodChannelTradplusPlugin();

  /// The default instance of [TradplusPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelTradplusPlugin].
  static TradplusPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TradplusPluginPlatform] when
  /// they register themselves.
  static set instance(TradplusPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
