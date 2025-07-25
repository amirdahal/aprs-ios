import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:radio/radio.dart' as radio;
import 'package:smart_rf/src/helpers/radio_extract.dart';

typedef RadioPosition = radio.Position;

class MyLocationProvider {
  final double latitude;
  final double longitude;
  final double? altitude;
  final DateTime timestamp;

  const MyLocationProvider({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.altitude,
  });

  Map<String, dynamic> toMap() {
    return {
      "Latitude": latitude,
      "Longitude": longitude,
      "Altitude": altitude,
      "Timestamp": timestamp.toIso8601String(),
    };
  }
}

ValueNotifier<MyLocationProvider?> myLocationProvider =
    ValueNotifier<MyLocationProvider?>(null);

final LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 30,
);

void determineGeoPosition() async {
  try {
    await handleGeoPositionPermission();
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((
      Position? position,
    ) {
      if (position != null) {
        myLocationProvider.value = MyLocationProvider(
          latitude: position.latitude,
          longitude: position.longitude,
          altitude: position.altitude,
          timestamp: position.timestamp,
        );

        if (kDebugMode) {
          print(
            "Position determined from GPS: ${myLocationProvider.value?.toMap()}",
          );
        }
      }
    });
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

Future<Position> handleGeoPositionPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  return await Geolocator.getCurrentPosition();
}

Future<void> getPosition() async {
  RadioPosition? position = await RadioExtract.radio.position();
  if (position != null) {
    myLocationProvider.value = MyLocationProvider(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude?.toDouble(),
      timestamp: position.time,
    );
    if (kDebugMode) {
      print(
        "Position determined from radio: ${myLocationProvider.value?.toMap()}",
      );
    }
  } else {
    determineGeoPosition();
  }
}

void determineRadioPosition() async {
  await handleGeoPositionPermission();
  await getPosition();
  Timer.periodic(const Duration(minutes: 1), (timer) async {
    await getPosition();
  });
}

void runLocationProviderResolver() {
  int firmwareVersion = RadioExtract.radio.deviceInfo.firmwareVersion;
  if (firmwareVersion >= 136) {
    if (kDebugMode) {
      print("Determine position from radio");
    }
    determineRadioPosition();
  } else {
    if (kDebugMode) {
      print("Determine position from GPS");
    }
    determineGeoPosition();
  }
}
