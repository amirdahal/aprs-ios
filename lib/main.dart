import 'package:aprs/src/helpers/theme.dart';
import 'package:aprs/src/screens/bluetooth_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: greenTheme,
      debugShowCheckedModeBanner: false,
      home: const BluetoothScreen(),
    );
  }
}
