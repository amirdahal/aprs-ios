import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:drr_radio_tracker/src/features/bluetooth/screens/bluetooth_screen.dart';
import 'package:drr_radio_tracker/src/widgets/buttons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<String> deniedPermissions = [];
  String runningTask = "";

  Future<void> _copyMBTilesToLocal() async {
    setState(() {
      runningTask = "Copying Map Assets";
    });

    final appDir = await getApplicationDocumentsDirectory();
    final localFile = File(path.join(appDir.path, 'phhi.omm.mbtiles'));

    if (kDebugMode) {
      print(appDir);
      print(localFile);
    }

    if (!localFile.existsSync()) {
      final byteData = await rootBundle.load('assets/phhi.omm.mbtiles');
      await localFile.writeAsBytes(byteData.buffer.asUint8List());
    }
    setState(() {
      runningTask = "";
    });
  }

  Future<void> _requestPermissions() async {
    setState(() {
      runningTask = "Requesting Permissions";
    });
    final permissions = {
      Permission.bluetooth: "Bluetooth",
      Permission.bluetoothScan: "Bluetooth Scan",
      Permission.bluetoothAdvertise: "Bluetooth Advertise",
      Permission.bluetoothConnect: "Bluetooth Connect",
      Permission.location: "Location",
    };

    List<String> denied = [];

    for (final entry in permissions.entries) {
      final permission = entry.key;
      final name = entry.value;

      final status = await permission.request();

      if (status.isGranted) {
        if (kDebugMode) print("$name permission granted");
      } else {
        if (kDebugMode) print("$name permission denied or permanently denied");
        denied.add(name);
      }
    }

    setState(() {
      deniedPermissions = denied;
    });
  }

  void _openAppSettings() {
    openAppSettings();
  }

  void launchApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BluetoothScreen()),
    );
  }

  void appSetup() async {
    await _copyMBTilesToLocal();
    await _requestPermissions();
    await _requestPermissions();
    if (deniedPermissions.isEmpty) {
      runningTask = "All permissions granted. Launching app now";
      Future.delayed(const Duration(seconds: 1), () {
        launchApp();
      });
    }
  }

  @override
  void initState() {
    appSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon.png', height: 200, width: 200),
            if (runningTask.isNotEmpty)
              AnimatedTextKit(
                isRepeatingAnimation: true,
                repeatForever: true,
                pause: const Duration(seconds: 1),
                animatedTexts: [
                  TyperAnimatedText(
                    runningTask,
                    textStyle: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(
                          fontFamily: 'SmoochSans',
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            const SizedBox(height: 24),

            if (deniedPermissions.isNotEmpty) ...[
              Text(
                'These permissions are required',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...deniedPermissions.map((p) => Text("- $p")),
              const SizedBox(height: 16),
              Button.outlined(
                onPressed: _openAppSettings,
                label: 'Open App Settings',
              ),
              // const SizedBox(height: 16),
              Text('And', style: Theme.of(context).textTheme.headlineSmall),
              Button.primary(onPressed: appSetup, label: 'Try again'),
            ],
          ],
        ),
      ),
    );
  }
}
