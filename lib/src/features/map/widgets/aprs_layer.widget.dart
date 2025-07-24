import 'package:aprs/src/features/aprs_log/screens/callsign_history.screen.dart';
import 'package:aprs/src/features/map/repository/location_service.repository.dart';
import 'package:aprs/src/helpers/event_handler.dart';
import 'package:aprs/src/helpers/utils.dart' show formatTimestamp;
import 'package:aprs/src/widgets/aprs_symbol.widget.dart';
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
                                  // leading: const Icon(
                                  //   Icons.perm_identity_rounded,
                                  // ),
                                  leading: AprsSymbolIcon(symbolTable: pos.symbolTable, symbol: pos.symbol),
                                  // title: Text(
                                  //   "${pos.symbolTable}${pos.symbol}",
                                  // ),
                                  subtitle: const Text("Symbol"),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                LocationRepository.openInMap(lat: pos.latitude, lng: pos.longitude);
                              },
                              child: const Text('Get direction'),
                            ),
                            TextButton(
                              onPressed: () {
                                LocationRepository.sharePosition(lat: pos.latitude, lng: pos.longitude, name: pos.source, address: pos.digipeaters.join(', '));
                              },
                              child: const Text('Share position'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CallsignPositionTrackerScreen(callsign: pos.source)));
                              },
                              child: const Text('History'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: AprsSymbolIcon(symbolTable: pos.symbolTable, symbol: pos.symbol),
                ),
              ),
          ],
        );
      },
    );
  }
}
