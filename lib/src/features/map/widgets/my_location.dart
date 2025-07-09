import 'package:aprs/src/features/map/repository/location_provider.dart'
    show determinePosition;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MyLocation extends StatelessWidget {
  final MapController mapController;
  MyLocation({super.key, required this.mapController});

  final ValueNotifier<LocationData?> myLocation = ValueNotifier<LocationData?>(
    null,
  );

  bool myLocationInit = false;

  Future<void> _checkLocation() async {
    try {
      Location location = await determinePosition();
      location.onLocationChanged.listen((locationData) {
        if (!myLocationInit) {
          myLocationInit = true;
          mapController.move(
            LatLng(locationData.latitude!, locationData.longitude!),
            10,
          );
        }
        myLocation.value = locationData;
        if (kDebugMode) {
          print(
            "Location: ${locationData.latitude} ${locationData.longitude} ${locationData.accuracy}",
          );
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
                    point: LatLng(location!.latitude!, location.longitude!),
                    child: Image.asset('assets/images/location.png'),
                  ),
                ],
              )
            : const Center();
      },
    );
  }
}
