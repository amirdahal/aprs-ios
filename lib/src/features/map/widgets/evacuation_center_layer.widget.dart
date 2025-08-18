import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:drr_radio_tracker/src/features/map/repository/location_service.repository.dart';
import 'package:drr_radio_tracker/src/model/model.dart';

class EvacuationCenterLayer extends StatefulWidget {
  final MapController mapController;
  const EvacuationCenterLayer({super.key, required this.mapController});

  @override
  State<EvacuationCenterLayer> createState() => _EvacuationCenterLayerState();
}

class _EvacuationCenterLayerState extends State<EvacuationCenterLayer> {
  List<EvacuationCentre> _centers = [];

  void loadEvacuationCenters() async {
    _centers = await EvacuationCentre().select().toList();
    setState(() {});
    widget.mapController.move(widget.mapController.camera.center, 8);
  }

  @override
  void initState() {
    loadEvacuationCenters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        for (var center in _centers)
          Marker(
            point: LatLng(center.latitude!, center.longitude!),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            trailing: Icon(Icons.location_on_outlined),
                            title: Text(center.name ?? ''),
                            subtitle: Text(center.address ?? ''),
                          ),
                          ListTile(
                            trailing: Icon(Icons.map_outlined),
                            title: Text('Get direction'),
                            onTap: () => LocationRepository.openInMap(
                              lat: center.latitude!,
                              lng: center.longitude!,
                            ),
                          ),
                          ListTile(
                            title: Text('Share with others'),
                            trailing: Icon(Icons.share),
                            onTap: () => LocationRepository.sharePosition(
                              lat: center.latitude!,
                              lng: center.longitude!,
                              name: center.name ?? 'Evacuation center',
                              address: center.address ?? '',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
                // widget.mapController.move( LatLng(center.latitude!, center.longitude!), 10);
              },
              child: Image.asset('assets/images/evacuation.png'),
            ),
          ),
      ],
    );
  }
}
