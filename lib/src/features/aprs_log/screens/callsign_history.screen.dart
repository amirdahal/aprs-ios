import 'dart:io';

import 'package:aprs/src/features/aprs_log/repository/aprs-log.repository.dart';
import 'package:aprs/src/features/aprs_log/repository/utils.dart';
import 'package:aprs/src/features/aprs_log/screens/packet-filter.screen.dart';
import 'package:aprs/src/features/aprs_log/widgets/packet-tile.widget.dart';
import 'package:aprs/src/features/map/repository/map_provider.dart';
import 'package:aprs/src/model/model.dart';
import 'package:aprs/src/widgets/aprs_symbol.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CallsignPositionTrackerScreen extends StatefulWidget {
  final String callsign;
  const CallsignPositionTrackerScreen({super.key, required this.callsign});

  @override
  State<CallsignPositionTrackerScreen> createState() =>
      _CallsignPositionTrackerScreenState();
}

class _CallsignPositionTrackerScreenState
    extends State<CallsignPositionTrackerScreen> {
  List<BeaconStore> _packets = [];
  List<BeaconStore> _uniquePositions = [];
  bool mapView = false;

  void _loadPackets({DateTime? start, DateTime? end}) async {
    _packets = await AprsLogRepository.getPackets(
      callsign: widget.callsign,
      start: start,
      end: end,
    );
    _uniquePositions = AprsLogRepository.getUniquePositions(_packets);
    setState(() {});
  }

  final mapController = MapController();
  double currentZoom = 7;
  final double maxZoom = 12;
  final double minZoom = 6;

  final Future<MbTiles> _mbtilesFuture;
  _CallsignPositionTrackerScreenState() : _mbtilesFuture = _loadMBTiles();

  static Future<MbTiles> _loadMBTiles() async {
    final appDir = await getApplicationDocumentsDirectory();
    final mbtilesPath = path.join(appDir.path, "phhi.omm.mbtiles");

    // Check if file exists
    if (!File(mbtilesPath).existsSync()) {
      throw Exception('MBTiles file not found at $mbtilesPath');
    }

    return MbTiles(mbtilesPath: mbtilesPath);
  }

  @override
  void initState() {
    _loadPackets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.callsign} Position History'),
        actions: [
          IconButton(
            onPressed: () async {
              final values = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PacketFilterScreen()),
              );
              _loadPackets(start: values[0], end: values[1]);
              if (kDebugMode) {
                print(values);
              }
            },
            icon: Icon(Icons.filter_list_alt),
          ),
        ],
      ),
      body: mapView
          ? FutureBuilder(
              future: _mbtilesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final mbtiles = snapshot.data!;

                final mapBounds = LatLngBounds(
                  const LatLng(
                    4.924031591010858,
                    116.46453531263894,
                  ), // Southwest (min lat, min lon)
                  const LatLng(
                    21.610332617571654,
                    127.21775507708352,
                  ), // Northeast (max lat, max lon)
                );

                return FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    maxZoom: maxZoom,
                    minZoom: minZoom,
                    initialZoom: currentZoom,
                    initialCenter: LatLng(
                      _uniquePositions.isNotEmpty
                          ? _packets[0].latitude!
                          : 12.151274550622965,
                      _uniquePositions.isNotEmpty
                          ? _packets[0].longitude!
                          : 122.36676560910182,
                    ),
                    interactionOptions: const InteractionOptions(
                      flags:
                          InteractiveFlag.drag | InteractiveFlag.flingAnimation,
                    ),
                  ),
                  children: [
                    TileLayer(
                      tileProvider: MBTilesImageProvider(mbtiles),
                      tileBounds: mapBounds,
                      // tileDimension: 256,
                      tileDisplay: const TileDisplay.fadeIn(),
                    ),
                    MarkerLayer(
                      markers: [
                        for (var pos in _uniquePositions)
                          Marker(
                            point: LatLng(pos.latitude!, pos.longitude!),
                            child: AprsSymbolIcon(symbolTable: pos.symbolTable!, symbol: pos.symbol!),
                          ),
                      ],
                    ),
                  ],
                );
              },
            )
          : ListView.builder(
              itemCount: _packets.length,
              itemBuilder: (context, index) {
                var packet = beaconStoreToPositionPacket(_packets[index]);
                return PacketTile(packet: packet, showTimestamp: true);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            mapView = !mapView;
          });
        },
        label: Row(
          spacing: 10,
          children: [
            Text(mapView ? 'List' : 'Map'),
            Icon(mapView ? Icons.list_outlined : Icons.map_outlined),
          ],
        ),
      ),
    );
  }
}
