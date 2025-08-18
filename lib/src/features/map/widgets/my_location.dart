import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:drr_radio_tracker/src/helpers/location_provider.dart'
    show myLocationProvider;

class MyLocation extends StatelessWidget {
  final MapController mapController;

  const MyLocation({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: myLocationProvider,
      builder: (context, location, _) {
        return location != null
            ? MarkerLayer(
                markers: [
                  Marker(
                    height: 50,
                    width: 50,
                    point: LatLng(location.latitude, location.longitude),
                    child: Image.asset('assets/images/location.png'),
                  ),
                ],
              )
            : const Center();
      },
    );
  }
}
