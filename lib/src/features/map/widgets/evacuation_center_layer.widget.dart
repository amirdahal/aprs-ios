import 'dart:io';

import 'package:aprs/src/model/model.dart';
import 'package:aprs/src/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      showToast(
        context: context,
        title: 'Get direction',
        description: 'Could not launch maps',
        type: ToastificationType.error,
      );
    }
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
                    return Column(
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
                          onTap: () async {
                            String googleMapsUrl =
                                'https://www.google.com/maps/search/?api=1&query=${center.latitude},${center.longitude}';
                            String appleMapsUrl =
                                'https://maps.apple.com/?q=${center.latitude},${center.longitude}';

                            final Uri url = Uri.parse(
                              Platform.isIOS || Platform.isMacOS
                                  ? appleMapsUrl
                                  : googleMapsUrl,
                            );
                            _launchUrl(url);
                          },
                        ),
                        ListTile(
                          title: Text('Share with others'),
                          trailing: Icon(Icons.share),
                          onTap: () async {
                            String googleMapsUrl =
                                'https://www.google.com/maps/search/?api=1&query=${center.latitude},${center.longitude}';
                            String appleMapsUrl =
                                'https://maps.apple.com/?q=${center.latitude},${center.longitude}';

                            final Uri url = Uri.parse(
                              Platform.isIOS || Platform.isMacOS
                                  ? appleMapsUrl
                                  : googleMapsUrl,
                            );
                            final result = await SharePlus.instance.share(
                              ShareParams(
                                title: '${center.name} ${center.address}',
                                subject: '${center.name} ${center.address}',
                                text:
                                    'I am sharing an address to the evacuation center named "${center.name}" located at "${center.address}". Use the provided url to reach there.',
                                uri: url,
                              ),
                            );
                            if (result.status == ShareResultStatus.success) {
                              showToast(
                                context: context,
                                title: 'Shared evacuation center location',
                                description: '',
                              );
                            }
                          },
                        ),
                      ],
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
