import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:drr_radio_tracker/src/features/map/repository/map_provider.dart'
    show MBTilesImageProvider;
import 'package:drr_radio_tracker/src/features/map/widgets/aprs_layer.widget.dart';
import 'package:drr_radio_tracker/src/features/map/widgets/double_channel_switch.dart';
import 'package:drr_radio_tracker/src/features/map/widgets/evacuation_center_layer.widget.dart';
import 'package:drr_radio_tracker/src/features/map/widgets/gis_layer.widget.dart'
    show GisLayer;
import 'package:drr_radio_tracker/src/features/map/widgets/layer.widget.dart';
import 'package:drr_radio_tracker/src/features/map/widgets/my_location.dart';
import 'package:drr_radio_tracker/src/helpers/location_provider.dart';
import 'package:drr_radio_tracker/src/helpers/my_position.util.dart';
import 'package:drr_radio_tracker/src/widgets/toast.dart';
import 'package:toastification/toastification.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapController = MapController();
  final Future<MbTiles> _mbtilesFuture;
  _MapScreenState() : _mbtilesFuture = _loadMBTiles();

  double currentZoom = 7;
  final double maxZoom = 12;
  final double minZoom = 6;

  MapLayer selectedLayer = MapLayer.aprsLayer;

  bool showMyPosition = false;

  static Future<MbTiles> _loadMBTiles() async {
    final appDir = await getApplicationDocumentsDirectory();
    final mbtilesPath = path.join(appDir.path, "phhi.omm.mbtiles");

    if (!File(mbtilesPath).existsSync()) {
      throw Exception('MBTiles file not found at $mbtilesPath');
    }

    return MbTiles(mbtilesPath: mbtilesPath);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
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
              initialCenter: const LatLng(
                12.151274550622965,
                122.36676560910182,
              ),
              interactionOptions: const InteractionOptions(
                flags:
                    InteractiveFlag.drag |
                    InteractiveFlag.flingAnimation |
                    InteractiveFlag.pinchZoom,
              ),
            ),
            children: [
              TileLayer(
                tileProvider: MBTilesImageProvider(mbtiles),
                tileBounds: mapBounds,
                // tileDimension: 256,
                tileDisplay: const TileDisplay.fadeIn(),
              ),
              Positioned(
                right: 30,
                bottom: 70,
                child: Column(
                  spacing: 10,
                  children: [
                    if (showMyPosition)
                      IconButton.filled(
                        onPressed: () {
                          MyLocationProvider? myLocation =
                              myLocationProvider.value;
                          if (myLocation != null) {
                            mapController.move(
                              LatLng(myLocation.latitude, myLocation.longitude),
                              currentZoom,
                            );
                          } else {
                            showToast(
                              context: context,
                              title: 'Unable to determine current position',
                              description: 'Please try again in a while.',
                              type: ToastificationType.error,
                            );
                          }
                        },
                        icon: Icon(Icons.my_location),
                        enableFeedback: true,
                        tooltip: 'My position',
                      ),
                    if (enablePositionSharing)
                      IconButton.filled(
                        onPressed: () {
                          setState(() {
                            showMyPosition = !showMyPosition;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            showMyPosition ? Colors.green : Colors.red,
                          ),
                        ),
                        icon: Icon(
                          showMyPosition
                              ? Icons.location_on_outlined
                              : Icons.location_off_outlined,
                        ),
                        enableFeedback: true,
                        tooltip: showMyPosition
                            ? 'Hide my position'
                            : 'Show my position',
                      ),
                    IconButton.filled(
                      onPressed: () {
                        setState(() {
                          if (currentZoom < maxZoom) {
                            currentZoom = currentZoom + 1;
                            mapController.move(
                              mapController.camera.center,
                              currentZoom,
                            );
                          }
                        });
                      },
                      tooltip: 'Zoom in',
                      icon: const Icon(Icons.zoom_in),
                    ),
                    IconButton.filled(
                      onPressed: () {
                        if (currentZoom > minZoom) {
                          currentZoom = currentZoom - 1;
                          mapController.move(
                            mapController.camera.center,
                            currentZoom,
                          );
                        }
                      },
                      tooltip: 'Zoom out',
                      icon: const Icon(Icons.zoom_out),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: MapLayerMenu(
                  initialLayer: MapLayer.aprsLayer,
                  onChanged: (layer) {
                    setState(() {
                      selectedLayer = layer;
                    });
                  },
                ),
              ),
              if (showMyPosition && enablePositionSharing)
                MyLocation(mapController: mapController),
              DoubleChannelSwitch(),

              switch (selectedLayer) {
                MapLayer.aprsLayer => AprsLayer(),
                MapLayer.gisLayer => GisLayer(),
                MapLayer.evacuationCentreLayer => EvacuationCenterLayer(
                  mapController: mapController,
                ),
              },
            ],
          );
        },
      ),
    );
  }
}
