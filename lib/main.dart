import 'dart:io';

import 'package:aprs/src/features/bluetooth/screens/bluetooth_screen.dart';
import 'package:aprs/src/helpers/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
