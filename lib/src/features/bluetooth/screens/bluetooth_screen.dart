import 'package:aprs/src/features/bluetooth/repository/bluetooth_scanner.dart';
import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:aprs/src/widgets/buttons.dart';
import 'package:aprs/src/widgets/scan_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Radio;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:radio/radio.dart';

import '../../home_screen.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  bool isScanning = false;
  bool isConnecting = false;
  BluetoothScanner scanner = BluetoothScanner();
  List<BluetoothDevice> _devices = [];

  Future<void> _startScan() async {
    setState(() {
      isScanning = true;
    });

    _devices = await scanner.scan();
    if (kDebugMode) {
      print(_devices);
    }
    setState(() {
      isScanning = false;
    });
  }

  void toHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  Future<void> _connect(BluetoothDevice device) async {
    setState(() {
      isConnecting = true;
    });
    RadioExtract.radio = Radio(device);
    try {
      await RadioExtract.radio.connect();
      if (kDebugMode) {
        print("Connection to radio successful");
      }
      // RadioExtract.radio.addEventHandler(radioEventsHandler);

      toHome();
    } on Exception catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    } finally {
      setState(() {
        isConnecting = false;
      });
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
      appBar: AppBar(
        title: Text(
          "Radio",
          style: TextTheme.of(
            context,
          ).headlineLarge?.copyWith(color: Colors.white),
        ),
      ),
      body: isScanning || isConnecting
          ? Center(
              child: LoadingIndicator(
                icon: isScanning
                    ? Icons.bluetooth_searching_outlined
                    : Icons.bluetooth_audio_sharp,
              ),
            )
          : _devices.isNotEmpty
          ? ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                var device = _devices[index];
                return ListTile(
                  title: Text(device.advName),
                  subtitle: Text(device.remoteId.str),
                  trailing: Button.primary(
                    label: "Connect",
                    onPressed: () => _connect(device),
                  ),
                );
              },
            )
          : Center(
              child: Column(
                children: [
                  Text(
                    "No devices found",
                    style: TextTheme.of(context).bodyLarge,
                  ),
                  Button.icon(
                    icon: Icons.bluetooth_searching_outlined,
                    onPressed: _startScan,
                  ),
                ],
              ),
            ),
      floatingActionButton: isScanning || isConnecting
          ? null
          : FloatingActionButton(
              onPressed: _startScan,
              child: Icon(Icons.bluetooth_searching_outlined),
            ),
    );
  }
}
