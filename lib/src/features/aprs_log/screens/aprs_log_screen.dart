import 'package:aprs/src/features/aprs_log/repository/aprs-log.repository.dart';
import 'package:aprs/src/features/aprs_log/repository/utils.dart';
import 'package:aprs/src/features/aprs_log/screens/callsign_history.screen.dart';
import 'package:aprs/src/features/aprs_log/widgets/packet-tile.widget.dart';
import 'package:aprs/src/helpers/event_handler.dart';
import 'package:aprs/src/model/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AprsLogScreen extends StatefulWidget {
  const AprsLogScreen({super.key});

  @override
  State<AprsLogScreen> createState() => _AprsLogScreenState();
}

class _AprsLogScreenState extends State<AprsLogScreen> {
  bool live = true;
  List<BeaconStore> _storedPositions = [];

  Future<void> getLogs() async {
    _storedPositions = await AprsLogRepository.getUniquePackets();
    setState(() {});

    if (kDebugMode) {
      print(_storedPositions);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aprs Logs')),
      body: live
          ? ValueListenableBuilder(
              valueListenable: aprsPositionPackets,
              builder: (context, value, child) {
                var invertedList = value.reversed.toList();
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    var packet = invertedList[index];
                    return PacketTile(
                      packet: packet,
                      showTimestamp: true,
                      minTimestamp: true,
                    );
                  },
                );
              },
            )
          : ListView.builder(
              itemCount: _storedPositions.length,
              itemBuilder: (context, index) {
                var packet = beaconStoreToPositionPacket(
                  _storedPositions[index],
                );
                return PacketTile(
                  packet: packet,
                  minTitle: true,
                  trailing: IconButton(
                    tooltip: 'See full history',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallsignPositionTrackerScreen(
                            callsign: packet.source,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.history),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          setState(() {
            live = !live;
          });
          if (!live) {
            await getLogs();
          }
        },
        label: Row(
          children: [
            Text(live ? 'History' : "Live"),
            const SizedBox(width: 5),
            Icon(
              live ? Icons.location_history_outlined : Icons.location_on_sharp,
            ),
          ],
        ),
      ),
    );
  }
}
