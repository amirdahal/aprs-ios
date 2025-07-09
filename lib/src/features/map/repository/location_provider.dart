import 'dart:async';

import 'package:custom_events/custom_events.dart';
import 'package:location/location.dart';
// import 'package:http/http.dart' as http;

Future<Location> determinePosition() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  // LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      Future.error("Error: Location service not enabled");
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      Future.error("Error: Location permission not granted");
    }
  }

  return location;
}

Future<void> startDrr() async {
  Timer? intervalTimer;
  CustomEvents appEvent = CustomEvents.instance;
  Location location = await determinePosition();

  // appEvent.addEventListener(MyEvents.drrSettingChangedEvent, (DrrStore drr) {
  //   intervalTimer?.cancel();
  //   if (drr.sendMyPosition!) {
  //     intervalTimer =
  //         Timer.periodic(Duration(minutes: drr.interval!), (timer) async {
  //           LocationData loc = await location.getLocation();
  //           await runScheduledTask(drr, loc);
  //         });
  //   }
  // });
  //
  // DrrStore? drr = await getDrrSetting();
  // if (drr != null) {
  //   appEvent.dispatchEvent(MyEvents.drrSettingChangedEvent, value: drr);
  // }
}

//
// Future<void> runScheduledTask(DrrStore drr, LocationData location) async {
//   if (kDebugMode) {
//     print("Send position to DRR");
//   }
//
//   DateTime now = DateTime.now();
//   showToast(navigatorKey.currentState!.context, "Sending drr");
//
//   try {
//     var url = Uri.http(
//       drrUrl,
//       'api/aprs-device-location/${drr.uuid}',
//     );
//
//     var response = await http.post(
//       url,
//       body: {
//         'latitude': location.latitude.toString(),
//         'longitude': location.longitude.toString(),
//         'altitude': location.altitude.toString(),
//         'comment': RadioInfo.aprsSetting.beaconMessage,
//         'recorded_at': formatDateTime(now)
//       },
//     );
//
//     if (kDebugMode) {
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');
//     }
//   } on Exception catch (e) {
//     if (kDebugMode) {
//       print("Send drr error: $e");
//     }
//   }
// }
