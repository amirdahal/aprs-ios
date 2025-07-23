import 'package:aprs/src/helpers/event_handler.dart';
import 'package:aprs/src/helpers/utils.dart' show formatTimestamp;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AprsLayer extends StatelessWidget {
  const AprsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: aprsPositionPackets,
      builder: (context, value, child) {
        return MarkerLayer(
          markers: [
            for (var pos in value)
              Marker(
                point: LatLng(pos.latitude, pos.longitude),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(pos.source),
                          content: SingleChildScrollView(
                            // Better than ListView for small content
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.location_on),
                                  title: Text(
                                    '${pos.latitude.toStringAsFixed(6)}, '
                                    '${pos.longitude.toStringAsFixed(6)}',
                                  ),
                                  subtitle: const Text("Position"),
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.comment_bank_outlined,
                                  ),
                                  title: Text(pos.comment),
                                  subtitle: const Text("Comment"),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.timelapse),
                                  title: Text(
                                    formatTimestamp(
                                      pos.timestamp,
                                    ), // Format the timestamp
                                  ),
                                  subtitle: const Text("Last seen"),
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.perm_identity_rounded,
                                  ),
                                  title: Text(
                                    "${pos.symbolTable}${pos.symbol}",
                                  ),
                                  subtitle: const Text("Symbol"),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.location_on,
                    size: 30,
                    color: Colors.purple,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
