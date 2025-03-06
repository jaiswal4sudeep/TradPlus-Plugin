package com.example.tradplus_plugin;

import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.tradplus.ads.base.TradPlus;
import com.tradplus.ads.base.bean.TPAdError;
import com.tradplus.ads.base.bean.TPAdInfo;
import com.tradplus.ads.open.TradPlusSdk;
import com.tradplus.ads.open.interstitial.InterstitialAdListener;
import com.tradplus.ads.open.interstitial.TPInterstitial;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class TradplusPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private static final String CHANNEL = "tradplus_plugin";
    private static final String TAG = "TradplusPlugin";

    private MethodChannel channel;
    private Activity activity;
    private TPInterstitial tpInterstitial;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "initializeSdk":
                String appId = call.argument("appId");
                boolean initSuccess = initializeSdk(appId);
                result.success(initSuccess);
                break;
            case "loadAd":
                String adUnitId = call.argument("adUnitId");
                boolean loadSuccess = loadAd(adUnitId);
                result.success(loadSuccess);
                break;
            case "showAd":
                boolean showSuccess = showAd();
                result.success(showSuccess);
                break;
            default:
                result.notImplemented();
        }
    }

    private boolean initializeSdk(@Nullable String appId) {
        if (activity == null || appId == null) {
            Log.e(TAG, "Cannot initialize SDK. Activity or App ID is null.");
            return false;
        }
        TradPlusSdk.initSdk(activity.getApplicationContext(), appId);
        Log.d(TAG, "TradPlus SDK initialized successfully.");
        return true;
    }

    private boolean loadAd(@Nullable String adUnitId) {
        if (activity == null || adUnitId == null) {
            Log.e(TAG, "Cannot load ad. Activity or Ad Unit ID is null.");
            return false;
        }

        if (tpInterstitial != null) {
            tpInterstitial = null;
        }

        tpInterstitial = new TPInterstitial(activity, adUnitId);
        tpInterstitial.setAdListener(new InterstitialAdListener() {
            @Override
            public void onAdLoaded(TPAdInfo tpAdInfo) { 
                Log.d(TAG, "Ad Loaded Successfully.");
                channel.invokeMethod("onAdLoaded", true);
            }
            @Override
            public void onAdClicked(TPAdInfo tpAdInfo) { Log.d(TAG, "Ad Clicked."); }
            @Override
            public void onAdImpression(TPAdInfo tpAdInfo) { Log.d(TAG, "Ad Impression Recorded."); }
            @Override
            public void onAdFailed(TPAdError error) { 
                Log.e(TAG, "Ad Failed: " + (error != null ? error.getErrorMsg() : "Unknown Error"));
                channel.invokeMethod("onAdFailed", false);
            }
            @Override
            public void onAdClosed(TPAdInfo tpAdInfo) { Log.d(TAG, "Ad Closed."); }
            @Override
            public void onAdVideoError(TPAdInfo tpAdInfo, TPAdError tpAdError) { Log.d(TAG, "Ad Video Error."); }
            @Override
            public void onAdVideoStart(TPAdInfo tpAdInfo) { Log.d(TAG, "Ad Video Started."); }
            @Override
            public void onAdVideoEnd(TPAdInfo tpAdInfo) { Log.d(TAG, "Ad Video Ended."); }
        });

        tpInterstitial.loadAd();
        Log.d(TAG, "Ad Load Request Sent.");
        return true;
    }

    private boolean showAd() {
        if (tpInterstitial == null || !tpInterstitial.isReady()) {
            Log.e(TAG, "Cannot show ad. Not ready.");
            return false;
        }
        tpInterstitial.showAd(activity, null);
        Log.d(TAG, "Ad shown successfully.");
        return true;
    }
}
