import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Radio;
import 'package:flutter_blue_plus_windows/flutter_blue_plus_windows.dart';
import 'package:radio/radio.dart';
import 'package:drr_radio_tracker/src/features/bluetooth/repository/bluetooth_scanner.dart';
import 'package:drr_radio_tracker/src/features/home_layout.dart';
import 'package:drr_radio_tracker/src/helpers/radio_extract.dart';
import 'package:drr_radio_tracker/src/widgets/buttons.dart';
import 'package:drr_radio_tracker/src/widgets/scan_indicator.dart';
import 'package:drr_radio_tracker/src/widgets/toast.dart';
import 'package:toastification/toastification.dart';

import '../../help/screens/help.screen.dart';
import '../repository/bonding.repository.dart';

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

  void toHome(String deviceName) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeLayout(connectedDeviceName: deviceName),
      ),
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
      toHome(device.advName);
    } catch (error) {
      RadioExtract.radio.dispose();
      showToast(
        context: context,
        title: 'Connection error',
        description: 'Failed to connect to device. Try again',
        type: ToastificationType.error,
      );
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
        title: Row(
          children: [
            Image.asset('assets/icon.png', height: 60, width: 60),
            Text("DRR Radio Tracker"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const HelpScreen())),
          ),
        ],
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
                    onPressed: () async {
                      await device.disconnect();
                      if (Platform.isAndroid) {
                        bool bonded = await isBonded(device);
                        if (!bonded) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Device not paired'),
                                content: Text(
                                  'Turn on pairing mode on the radio and click on Continue',
                                ),
                                actions: [
                                  Button.outlined(
                                    label: 'Cancel',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Button.primary(
                                    label: 'Connect',
                                    onPressed: () {
                                      _connect(device);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          _connect(device);
                        }
                      } else {
                        _connect(device);
                      }
                    },
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button.icon(
                    icon: Icons.bluetooth_searching_outlined,
                    onPressed: _startScan,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "No devices found",
                    style: TextTheme.of(context).headlineSmall,
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
