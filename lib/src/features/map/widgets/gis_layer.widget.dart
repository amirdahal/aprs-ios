import 'package:aprs/src/features/map/repository/gis.repository.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';

class GisLayer extends StatefulWidget {
  const GisLayer({super.key});

  @override
  State<GisLayer> createState() => _GisLayerState();
}

class _GisLayerState extends State<GisLayer> {
  GeoJsonParser myGeoJson = GeoJsonParser();

  void loadGisData() async {
    String? gisData = await GisRepository.loadGisData();
    if (gisData != null) {
      if (kDebugMode) {
        print(myGeoJson.polygons);
        print(myGeoJson.polylines);
        print(myGeoJson.markers);
      }
    }
  }

  @override
  void initState() {
    loadGisData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PolygonLayer(polygons: myGeoJson.polygons),
        PolylineLayer(polylines: myGeoJson.polylines),
        MarkerLayer(markers: myGeoJson.markers),
      ],
    );
  }
}
