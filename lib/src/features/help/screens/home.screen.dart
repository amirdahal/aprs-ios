import 'package:drr_radio_tracker/src/features/help/constants/help.mixin.dart';
import 'package:flutter/material.dart';

class HelpHome extends StatelessWidget with HelpPageMixin {
  const HelpHome({super.key});
  @override
  Widget build(BuildContext context) {
    final features = [
      {
        "icon": Icons.bluetooth,
        "title": "Radio Connectivity",
        "description":
            "Connect with the radio over Bluetooth on Android and Windows.",
      },
      {
        "icon": Icons.settings,
        "title": "Radio Configuration",
        "description":
            "Configure general settings, APRS/BSS settings, and channel settings.",
      },
      {
        "icon": Icons.message_outlined,
        "title": "APRS Messaging",
        "description":
            "Send dedicated messages using CALLSIGN or broadcast using ALL. "
            "Messages can be filtered to show only those meant for your registered callsign.",
      },
      {
        "icon": Icons.map,
        "title": "Offline Maps",
        "description":
            "View peer positions on an offline map of the Philippines bundled with the app. "
            "Supports APRS, GIS, and Evacuation Center layers.",
      },
      {
        "icon": Icons.send,
        "title": "Crisis Communication",
        "description":
            "Communicate with the DRR center by sending coordinates. "
            "Choose to send your own position or all received positions.",
      },
      {
        "icon": Icons.dataset_rounded,
        "title": "Position Logging",
        "description":
            "Log all received positions in a local database for future tracking. "
            "Replay past peer movements as text or on the map.",
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(
              feature["icon"] as IconData,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              feature["title"] as String,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                feature["description"] as String,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  String get label => "About the app";
}
