import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:drr_radio_tracker/src/features/map/repository/gis.repository.dart';

class GisLayer extends StatefulWidget {
  const GisLayer({super.key});

  @override
  State<GisLayer> createState() => _GisLayerState();
}

class _GisLayerState extends State<GisLayer> {
  final Map<String, List<Polygon>> _admPolygons = {};
  String? _selectedLayer;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAllLayers();
  }

  Future<void> _loadAllLayers() async {
    try {
      final response = await GisRepository.loadGisData();
      if (response != null) {
        final data = jsonDecode(response) as Map<String, dynamic>;

        for (final entry in data.entries) {
          if (entry.key.endsWith('.geojson') &&
              entry.value['type'] == 'FeatureCollection') {
            final parser = GeoJsonParser();
            parser.parseGeoJson(entry.value);
            final layerName = entry.key.replaceAll('.geojson', '');
            _admPolygons[layerName] = parser.polygons;
          }
        }

        setState(() {
          _selectedLayer = _admPolygons.keys.first;
          _loading = false;
        });
      }
    } catch (e) {
      print('Error loading GeoJSON layers: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _selectedLayer == null) return const SizedBox();

    return Stack(
      children: [
        // Polygon Layer for selected ADM level
        PolygonLayer(polygons: _admPolygons[_selectedLayer!]!),

        // Dropdown for layer switching
        Positioned(
          top: 60,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLayer,
                items: _admPolygons.keys.map((layer) {
                  return DropdownMenuItem(
                    value: layer,
                    child: Text(_getLayerName(layer)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedLayer = value);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getLayerName(String str) {
    switch (str) {
      case 'adm0':
        return 'Country';
      case 'adm1':
        return 'Regions';
      case 'adm2':
        return 'Provinces';
      case 'adm3':
        return 'Municipalities';
      case 'adm4':
        return 'Barangays';
      default:
        return '';
    }
  }
}
