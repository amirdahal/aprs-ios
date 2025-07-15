import 'dart:io';

import 'package:aprs/src/features/bluetooth/screens/bluetooth_screen.dart';
import 'package:aprs/src/helpers/theme.dart';
import 'package:aprs/src/helpers/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

Future<void> copyMBTilesToLocal() async {
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
}

const WindowOptions windowOptions = WindowOptions(
  size: Size(800, 700),
  maximumSize: Size(800, 700),
  minimumSize: Size(800, 700),
  center: true,
  title: 'APRS Application',
  // titleBarStyle: TitleBarStyle.hidden,
  fullScreen: false,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (isLargeScreen) {
    await windowManager.ensureInitialized();

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setMaximizable(false);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await copyMBTilesToLocal();
  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: greenTheme,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const BluetoothScreen(),
    );
  }
}
