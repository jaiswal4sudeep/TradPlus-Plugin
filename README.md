# 📦 TradplusPlugin (Flutter)

A simple Flutter plugin wrapper for integrating and managing ads using the Tradplus SDK. This plugin helps you **initialize**, **load**, and **show ads** using method channels on Android/iOS platforms.

---

## 🚀 Features

- ✅ Initialize the Tradplus SDK  
- ✅ Load ads using a specific Ad Unit ID  
- ✅ Automatically load next ad after showing  
- ✅ Retry ad load if not loaded before showing  

---

## 📦 Installation

Add this plugin to your `pubspec.yaml`:

```yaml
dependencies:
  tradplus_plugin:
    path: ./path_to_your_plugin_directory
```

> Make sure you update the path accordingly if using it locally.

---

## 🛠️ Platform Setup

### Android

1. Add your Tradplus SDK dependencies in `android/app/build.gradle`.

2. Update `AndroidManifest.xml` with necessary permissions and meta-data.

### iOS

1. Add Tradplus SDK via CocoaPods.
2. Update `Info.plist` with necessary keys.

---

## 🧑‍💻 Usage

### 1️⃣ Initialize the SDK

```dart
final isInitialized = await TradplusPlugin.initializeSdk(
  appId: 'your_app_id_here',
  adUnitId: 'your_ad_unit_id_here',
);
```

> This also loads the first ad immediately after initialization.

---

### 2️⃣ Show an Ad

```dart
final isAdShown = await TradplusPlugin.showAd(adUnitId: 'your_ad_unit_id_here');
```

- If the ad is already loaded, it will be shown.
- If not, it will first attempt to load and then show the ad.

---

## 📄 Method Details

### `initializeSdk({required String appId, required String adUnitId})`

- Initializes the SDK with the provided `appId`.
- Loads the first ad using `adUnitId`.

### `_loadAd(String adUnitId)`

- Private method to load an ad.
- Sets `_isAdLoaded` accordingly.

### `showAd({required String adUnitId})`

- Shows the ad if already loaded.
- If not loaded, loads it first and then attempts to show.

---

## 📂 Plugin Code

```dart
import 'package:flutter/services.dart';

class TradplusPlugin {
  static const MethodChannel _channel = MethodChannel('tradplus_plugin');
  static bool _isAdLoaded = false;

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
```

---

## 📞 MethodChannel Mapping (Native Side)

| Dart Method     | Android/iOS Method to Handle  |
|----------------|-------------------------------|
| `initializeSdk` | Should trigger SDK init logic |
| `loadAd`        | Load ad from Tradplus SDK     |
| `showAd`        | Show the loaded ad            |

---

## 🧪 Testing Tips

- Use real `appId` and `adUnitId` from Tradplus dashboard.
- Test on real devices for ad delivery.

---

## 📃 License

MIT License. Free to use, modify, and distribute.