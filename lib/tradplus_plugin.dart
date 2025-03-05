
import 'tradplus_plugin_platform_interface.dart';

class TradplusPlugin {
  Future<String?> getPlatformVersion() {
    return TradplusPluginPlatform.instance.getPlatformVersion();
  }
}
