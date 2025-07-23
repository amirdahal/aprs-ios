import 'package:aprs/src/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EvacuationCenterLayer extends StatefulWidget {
  final MapController mapController;
  const EvacuationCenterLayer({super.key, required this.mapController});

  @override
  State<EvacuationCenterLayer> createState() => _EvacuationCenterLayerState();
}

class _EvacuationCenterLayerState extends State<EvacuationCenterLayer> {

  List<EvacuationCentre> _centers = [];

  void loadEvacuationCenters() async{
    _centers =  await EvacuationCentre().select().toList();
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
    return MarkerLayer(markers: [
      for(var center in _centers)
        Marker(
          point: LatLng(center.latitude!, center.longitude!),
          child: InkWell(
              onTap: () {
                widget.mapController.move( LatLng(center.latitude!, center.longitude!), 10);
              },
              child: Image.asset('assets/images/evacuation.png')),
        ),
    ]);
  }
}
