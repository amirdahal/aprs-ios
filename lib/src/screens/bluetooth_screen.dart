import 'package:aprs/src/helpers/bluetooth_scanner.dart';
import 'package:aprs/src/screens/home_screen.dart';
import 'package:aprs/src/widgets/scan_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  bool isScanning = false;
  BluetoothScanner scanner = BluetoothScanner();

  Future<void> _startScan() async {
    setState(() {
      isScanning = true;
    });

    List<BluetoothDevice> devices = await scanner.scan();
    if (kDebugMode) {
      print(devices);
    }
  }

  @override
  void initState() {
    _startScan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isScanning
          ? Center(
              child: LoadingIndicator(icon: Icons.bluetooth_searching_outlined),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: Text("Bluetooth screen")),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text("Switch to main screen"),
                ),
              ],
            ),
      floatingActionButton: isScanning
          ? null
          : FloatingActionButton(
              onPressed: _startScan,
              child: Icon(Icons.bluetooth_searching),
            ),
    );
  }
}
