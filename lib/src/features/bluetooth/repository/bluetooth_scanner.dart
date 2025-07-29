import 'package:flutter_blue_plus_windows/flutter_blue_plus_windows.dart';

class BluetoothScanner {
  Future<List<BluetoothDevice>> scan() async {
    List<BluetoothDevice> devices = [];

    await FlutterBluePlus.turnOn();

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    final subscription = FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        if (!devices.any((d) => d.remoteId == result.device.remoteId)) {
          if (result.device.remoteId.str.startsWith("38:D2")) {
            devices.add(result.device);
          }
        }
      }
    });

    await Future.delayed(const Duration(seconds: 10));

    await FlutterBluePlus.stopScan();
    await subscription.cancel();

    Set<BluetoothDevice> deviceSet = devices.map((d) => d).toSet();
    return deviceSet.toList();
  }
}
