import 'package:aprs/src/features/bluetooth/screens/bluetooth_screen.dart';
import 'package:aprs/src/helpers/theme.dart';
import 'package:flutter/material.dart';

void main() {
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
