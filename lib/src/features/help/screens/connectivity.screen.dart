import 'package:drr_radio_tracker/src/features/help/widgets/builder.widget.dart';
import 'package:flutter/material.dart';

import '../constants/help.mixin.dart';

class ConnectivityHelpScreen extends StatelessWidget with HelpPageMixin {
  ConnectivityHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        BuildSection(
          title: "Bluetooth Overview",
          content:
              "The application uses Bluetooth to connect with your radio. "
              "Some radios show up as both an audio device and a control device. "
              "The app needs to connect to the control device.",
        ),

        const SizedBox(height: 24),

        BuildSection(
          title: "Connecting on Android",
          content:
              "1. Launch the app and scan for nearby devices.\n"
              "2. If the radio is already paired, simply select it and connect.\n"
              "3. If the radio is not yet paired, the app will prompt you to turn on pairing mode.\n"
              "4. Enable pairing mode on your radio and tap *Connect* in the app.\n",
        ),

        const SizedBox(height: 24),

        BuildSection(
          title: "Connecting on Windows",
          content:
              "On Windows, pairing can be tricky because the radio appears as two devices: "
              "an audio device and a control device. The app requires the control device.\n\n"
              "Follow these steps:",
        ),
        BuildSteps(
          steps: [
            "In the Windows Bluetooth dialog, remove the radio audio device if it was previously paired.",
            "Put the radio in pairing mode and keep the 'Pairing' option on screen.",
            "On Windows, click 'Add Device' and select the radio's audio device.",
          ],
        ),
        BuildImage(
          imageName: "pair_audio_device.png",
          caption: "Pairing to audio device",
        ),
        BuildSteps(
          steps: [
            "Once connected, pairing mode will turn off on the radio.",
            "Re-enable pairing mode on the radio.",
            "On Windows, click 'Add Device' again, then select 'Show all devices'.",
          ],
        ),
        BuildImage(
          imageName: "show_all_devices.png",
          caption: "Show all devices to find control device",
        ),
        BuildSteps(
          steps: ["Select and pair to the control device of the radio."],
        ),
        BuildImage(
          imageName: "pair_control_device.png",
          caption: "Control device pairing",
        ),
        const SizedBox(height: 12),
        BuildImage(
          imageName: "successful_pairing.png",
          caption: "Successful pairing result",
        ),
        const SizedBox(height: 16),
        const Text(
          "⚠️ Pairing may take a few tries. Be patient. Once both audio and control devices "
          "are paired, the radio should connect correctly.",
          style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
        ),

        const SizedBox(height: 24),

        BuildSection(
          title: "Troubleshooting",
          content:
              "- Restart the radio and try again.\n"
              "- Make sure the radio is not connected to another device.\n"
              "- If the radio is already connected to your phone/PC but not responding, "
              "restart Bluetooth and relaunch the app.\n"
              "- Clear Bluetooth cache on your phone if issues persist.\n"
              "- As a last step, restart your phone or PC and retry.",
        ),
      ],
    );
  }

  @override
  String get label => "How to Connect";
}
