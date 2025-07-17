import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<bool> isBonded(BluetoothDevice device) async {
  final currentState = await device.bondState.first;
  return currentState == BluetoothBondState.bonded;
}
