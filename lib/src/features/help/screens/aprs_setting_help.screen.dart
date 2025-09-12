import 'package:drr_radio_tracker/src/features/help/constants/help.mixin.dart';
import 'package:drr_radio_tracker/src/features/help/widgets/builder.widget.dart';
import 'package:flutter/material.dart';

class AprsSettingHelpScreen extends StatelessWidget with HelpPageMixin {
  const AprsSettingHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        BuildSection(
          title: "Understanding beacon settings",
          content:
              "This guide will help you understand the various beacon settings available in the app and how to configure them for optimal performance.",
        ),
        const Divider(height: 32),

        BuildSection(
          title: "1. Packet format",
          content:
              "Type of packet for position and message sharing. Recommended to APRS using the app",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "2. Aprs callsign",
          content:
              "It's your amateur radio callsign (e.g., 'YOURCALL'), prefixed to beacons with SSID",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "3. Aprs ssid",
          content:
              "It's the SSID (Secondary Station ID) appended to your callsign (e.g., YOURCALL-9), distinguishing roles like primary (0), APRS (9), or tracker (15).",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "4. BSS user id",
          content:
              "It's a unique ID for beaconing users, allowing the radio to tag beacons with a non-callsign identifier.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "5. Identification information ",
          content:
              "It appends a user-defined ID string (e.g., 'HIKE29') to the beacon upon PTT release, enriching the packet with context.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "6. Message",
          content:
              "It's the custom comment or message field in APRS packets (e.g., 'Enroute to summit'), up to 65 characters, sent with position data.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "7. Location sharing",
          content:
              "It enables or disables overall location sharing via beacons, the master switch for APRS visibility"
              "Options range from 10 seconds to 30 minutes. Recommended not to use lower interval to save channel bandwidth. Select 'Off' to disable location sharing",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "8. Allow position check",
          content:
              "It permits or blocks position queries from other stations, controlling who can request your location—true for interactive APRS, false for passive broadcasting.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "9. Send power voltage",
          content:
              "It includes the radio's battery voltage in the packet, allowing remote monitoring of power levels—useful for long operations to spot low battery before it fails.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "10. Send location on PTT release",
          content:
              "It triggers a location beacon upon PTT release, capturing your position right after a voice call—handy for logging where you were during a QSO.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "11. Send BSS user ID",
          content:
              "It includes a BSS user ID in the PTT-release beacon, perhaps for integrated tracking or multi-user networks",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "12. Send ID information",
          content:
              "It appends identification information (like your callsign or ID) to the location beacon, making it more informative for recipients.",
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  String get label => "Aprs settings guide";
}
