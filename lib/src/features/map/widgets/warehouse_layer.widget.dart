import 'package:aprs/src/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WarehouseLayer extends StatefulWidget {
  final MapController mapController;
  const WarehouseLayer({super.key, required this.mapController});

  @override
  State<WarehouseLayer> createState() => _WarehouseLayerState();
}

class _WarehouseLayerState extends State<WarehouseLayer> {

  List<Warehouse> _warehouses = [];


  void loadWarehouses() async{
    _warehouses =  await Warehouse().select().toList();
    setState(() {});
    widget.mapController.move(widget.mapController.camera.center, 8);
  }

  @override
  void initState() {
    loadWarehouses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(markers: [
      for(var warehouse in _warehouses)
        Marker(
          point:  LatLng(warehouse.latitude!, warehouse.longitude!),
          child: InkWell(
              onTap: () {
                widget.mapController.move( LatLng(warehouse.latitude!, warehouse.longitude!), 10);
              },
              child: Image.asset('assets/images/warehouse.png')),
        ),
    ]);
  }
}
