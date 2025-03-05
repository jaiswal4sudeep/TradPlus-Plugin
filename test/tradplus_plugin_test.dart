import 'package:flutter_test/flutter_test.dart';
import 'package:tradplus_plugin/tradplus_plugin.dart';
import 'package:tradplus_plugin/tradplus_plugin_platform_interface.dart';
import 'package:tradplus_plugin/tradplus_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTradplusPluginPlatform
    with MockPlatformInterfaceMixin
    implements TradplusPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TradplusPluginPlatform initialPlatform = TradplusPluginPlatform.instance;

  test('$MethodChannelTradplusPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTradplusPlugin>());
  });

  test('getPlatformVersion', () async {
    TradplusPlugin tradplusPlugin = TradplusPlugin();
    MockTradplusPluginPlatform fakePlatform = MockTradplusPluginPlatform();
    TradplusPluginPlatform.instance = fakePlatform;

    expect(await tradplusPlugin.getPlatformVersion(), '42');
  });
}
