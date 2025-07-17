import 'dart:async';

import 'package:aprs/src/helpers/location_provider.dart'
    show determineGeoPosition, locationSettings;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MyLocation extends StatelessWidget {
  final MapController mapController;

  MyLocation({super.key, required this.mapController});

  final ValueNotifier<Position?> myLocation = ValueNotifier<Position?>(null);

  bool myLocationInit = false;
  late final StreamSubscription<Position> positionStream;

  Future<void> _checkLocation() async {
    try {
      await determineGeoPosition();

      positionStream =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen((Position? position) {
            if (position != null) {
              if (!myLocationInit) {
                myLocationInit = true;
                mapController.move(
                  LatLng(position.latitude, position.longitude),
                  10,
                );
              }
              myLocation.value = position;
              if (kDebugMode) {
                print(
                  "Location: ${position.latitude} ${position.longitude} ${position.accuracy}",
                );
              }
            }
          });
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Check location error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkLocation();
    return ValueListenableBuilder(
      valueListenable: myLocation,
      builder: (context, location, _) {
        return myLocationInit
            ? MarkerLayer(
                markers: [
                  Marker(
                    height: 50,
                    width: 50,
                    point: LatLng(location!.latitude, location.longitude),
                    child: Image.asset('assets/images/location.png'),
                  ),
                ],
              )
            : const Center();
      },
    );
  }
}
