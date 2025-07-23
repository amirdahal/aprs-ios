import 'package:flutter/material.dart';

enum MapLayer {
  aprsLayer(1),
  warehousesLayer(2),
  evacuationCentreLayer(3);

  final int layer;
  const MapLayer(this.layer);

  static MapLayer fromValue(int val) =>
      MapLayer.values.firstWhere((e) => e.layer == val);
}

class MapLayerMenu extends StatefulWidget {
  final MapLayer initialLayer;
  final void Function(MapLayer selected) onChanged;

  const MapLayerMenu({
    Key? key,
    required this.initialLayer,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<MapLayerMenu> createState() => _MapLayerMenuState();
}

class _MapLayerMenuState extends State<MapLayerMenu> {
  late MapLayer selectedLayer;

  @override
  void initState() {
    super.initState();
    selectedLayer = widget.initialLayer;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MapLayer>(
      icon:  Icon(Icons.layers, size: 40,),
      onSelected: (MapLayer layer) {
        setState(() {
          selectedLayer = layer;
        });
        widget.onChanged(layer);
      },
      itemBuilder: (BuildContext context) {
        return MapLayer.values.map((layer) {
          final isSelected = layer == selectedLayer;
          return PopupMenuItem<MapLayer>(
            value: layer,
            child: Text(
              _labelForLayer(layer),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
          );
        }).toList();
      },
    );
  }

  String _labelForLayer(MapLayer layer) {
    switch (layer) {
      case MapLayer.aprsLayer:
        return 'APRS';
      case MapLayer.warehousesLayer:
        return 'Warehouses';
      case MapLayer.evacuationCentreLayer:
        return 'Evacuation Centres';
    }
  }
}
