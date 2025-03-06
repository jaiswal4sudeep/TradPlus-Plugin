import 'package:flutter/services.dart';

class TradplusPlugin {
  static const MethodChannel _channel = MethodChannel('tradplus_plugin');

  static Future<bool> initializeSdk(String appId) async {
    try {
      final bool result = await _channel.invokeMethod('initializeSdk', {
        'appId': appId,
      });
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> showAd(String adUnitId) async {
    try {
      final bool isLoaded = await _channel.invokeMethod('loadAd', {
        'adUnitId': adUnitId,
      });

      if (isLoaded) {
        final bool isShown = await _channel.invokeMethod('showAd');
        return isShown;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
