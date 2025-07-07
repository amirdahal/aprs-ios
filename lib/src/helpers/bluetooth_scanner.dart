import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothScanner {
  Future<List<BluetoothDevice>> scan() async {
    await _requestPermissions();

    List<BluetoothDevice> devices = [];

    await FlutterBluePlus.turnOn();

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 10),
      withServices: [Guid("00001100-d102-11e1-9b23-00025b00a5a5")],
    );

    final subscription = FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        if (!devices.any((d) => d.id == result.device.id)) {
          devices.add(result.device);
        }
      }
    });

    await Future.delayed(const Duration(seconds: 10));

    await FlutterBluePlus.stopScan();
    await subscription.cancel();

    Set<BluetoothDevice> deviceSet = devices.map((d) => d).toSet();
    return deviceSet.toList();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.bluetooth.request().isGranted) {
      if (kDebugMode) {
        print("Bluetooth permission granted");
      }
    }
    if (await Permission.bluetoothScan.request().isGranted) {
      if (kDebugMode) {
        print("Bluetooth scan permission granted");
      }
    }
    if (await Permission.bluetoothAdvertise.request().isGranted) {
      if (kDebugMode) {
        print("Bluetooth advertise permission granted");
      }
    }
    if (await Permission.bluetoothConnect.request().isGranted) {
      if (kDebugMode) {
        print("Bluetooth connect permission granted");
      }
    }
    if (await Permission.location.request().isGranted) {
      if (kDebugMode) {
        print("Location permission granted");
      }
    }
  }
}
