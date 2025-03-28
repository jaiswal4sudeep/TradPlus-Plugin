import 'package:flutter/material.dart';
import 'package:tradplus_plugin/tradplus_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String status = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin Example App')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 25,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final bool init = await TradplusPlugin.initializeSdk(
                    appId: 'EE565D090FABE278A7F32D0FAFE0A471',
                    adUnitId: '3A46BF1E93DB77B6047429195B3AF153',
                  );
                  setState(() {
                    status =
                        init
                            ? '✅ TradPlus SDK Initialized Successfully'
                            : '❌ TradPlus SDK Initialization Failed';
                  });
                },
                child: Text('Initialize SDK'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final bool load = await TradplusPlugin.showAd(
                    adUnitId: '3A46BF1E93DB77B6047429195B3AF153',
                  );
                  setState(() {
                    status =
                        load
                            ? '✅ Ad Loaded Successfully'
                            : '❌ Ad Loading Failed';
                  });
                },
                child: Text('Show Ad'),
              ),
              Text(
                status,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
