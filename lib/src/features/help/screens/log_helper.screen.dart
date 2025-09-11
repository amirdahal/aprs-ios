import 'package:drr_radio_tracker/src/features/help/constants/help.mixin.dart';
import 'package:drr_radio_tracker/src/features/help/widgets/builder.widget.dart';
import 'package:flutter/material.dart';

class LogHelperScreen extends StatelessWidget with HelpPageMixin {
  const LogHelperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        BuildSection(
          title: "Logging and tracking",
          content:
              "The app can log APRS positions and track location over time. This is useful for reviewing your peers' movements, for safety purposes.",
        ),

        const SizedBox(height: 24),

        BuildSection(
          title: 'Viewing the logs',
          content:
              "To view the logs, go to the map screen and select 'Logs' icon (palced right next to message). Here you can see a list of all logged callsign with timestamp.",
        ),

        // BuildImage(imageName: "", caption: "List of logged callsigns"),
        // const SizedBox(height: 24),
        BuildSteps(
          steps: [
            "Select a callsign to view detailed logs including positions and timestamps. See image below.",
            "You can filter logs by date using the filter options on the top right corner.",
          ],
        ),
        Text(
          "**Position history tracking allows you to see where a callsign has been over time, both as text or on the map. To track the positions on the map, click on the 'Map' button placed in the bottom right corner.**",
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
        BuildImage(
          imageName: "callsign_log.png",
          caption: 'Callsign log details',
        ),
      ],
    );
  }

  @override
  String get label => "Logging and tracking";
}
