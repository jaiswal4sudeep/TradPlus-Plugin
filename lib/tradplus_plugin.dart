import 'package:flutter/services.dart';

class TradplusPlugin {
  static const MethodChannel _channel = MethodChannel('tradplus_plugin');
  static bool _isAdLoaded = false;

  //! ✅ Initialize SDK & Load First Ad
  static Future<bool> initializeSdk({
    required String appId,
    required String adUnitId,
  }) async {
    try {
      final bool result = await _channel.invokeMethod('initializeSdk', {
        'appId': appId,
      });

      if (result) {
        _loadAd(adUnitId);
      }

      return result;
    } catch (e) {
      return false;
    }
  }

  //! ✅ Load an Ad
  static Future<void> _loadAd(String adUnitId) async {
    try {
      final bool isLoaded = await _channel.invokeMethod('loadAd', {
        'adUnitId': adUnitId,
      });

      _isAdLoaded = isLoaded;
    } catch (e) {
      _isAdLoaded = false;
    }
  }

  //! ✅ Show Ad (If Loaded) or Load & Show
  static Future<bool> showAd({required String adUnitId}) async {
    try {
      if (_isAdLoaded) {
        final bool isShown = await _channel.invokeMethod('showAd');
        if (isShown) {
          _isAdLoaded = false;
          _loadAd(adUnitId);
        }
        return isShown;
      } else {
        await _loadAd(adUnitId);
        return await showAd(adUnitId: adUnitId);
      }
    } catch (e) {
      return false;
    }
  }
}
