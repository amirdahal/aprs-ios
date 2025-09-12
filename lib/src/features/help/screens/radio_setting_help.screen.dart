import 'package:drr_radio_tracker/src/features/help/constants/help.mixin.dart';
import 'package:drr_radio_tracker/src/features/help/widgets/builder.widget.dart';
import 'package:flutter/material.dart';

class RadioSettingHelpScreen extends StatelessWidget with HelpPageMixin {
  const RadioSettingHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        BuildSection(
          title: "Understanding radio settings",
          content:
              "This guide will help you understand the various radio settings available in the app and how to configure them for optimal performance.\n"
              "Select the type of radio you are using. Common types include VHF, UHF, and HF. Ensure you choose the correct type to match your hardware.",
        ),

        const Divider(height: 32),

        BuildSection(
          title: "1. Repeater mode",
          content:
              "Enables automatic relaying (e.g., APRS digipeating or repeater mode).",
        ),

        const SizedBox(height: 16),

        BuildSection(
          title: "2. Scan",
          content:
              "Enables/disables channel scanning to monitor multiple frequencies.",
        ),

        const SizedBox(height: 16),

        BuildSection(
          title: "3. Double channel",
          content:
              "Specifies the active channel for VFO B, typically for another band (e.g., UHF)."
              "Options to choose from:\n"
              "- OFF: Disable double channel mode.\n"
              "- A: Listen to primary channel only\n"
              "- B: Listen to secondary channel only\n",
        ),

        const SizedBox(height: 16),

        BuildSection(
          title: "4. Channel A",
          content:
              "Specifies the active channel for VFO A (Variable Frequency Oscillator A), typically used for one band (e.g., VHF).",
        ),
        const SizedBox(height: 16),
        BuildSection(
          title: "5. Channel B",
          content:
              "Specifies the active channel for VFO B, typically for another band (e.g., UHF).",
        ),

        const SizedBox(height: 16),
        BuildSection(
          title: "6. Enable BT mic",
          content:
              "Configures Advanced Generic Hands-Free Profile (AGHFP) mode for Bluetooth audio/call functionality.",
        ),

        const SizedBox(height: 16),
        BuildSection(
          title: "7. Tail elimination",
          content:
              "Enables/disables squelch tail elimination to reduce the “hiss” after transmission.",
        ),

        const SizedBox(height: 16),
        BuildSection(
          title: "8. Auto power on",
          content: "Enables automatic power-on when connected to power.",
        ),

        const SizedBox(height: 16),
        BuildSection(
          title: "9. Mic gain",
          content:
              "Sets microphone gain level for audio input sensitivity.\n"
              "Available options:\n"
              "- 1: Low\n"
              "- 2: Medium\n"
              "- 3: High\n",
        ),

        // const SizedBox(height: 10),
        BuildSection(
          title: "10. Bluetooth mic gain",
          content:
              "Sets bluetooth microphone gain level for audio input sensitivity.\n"
              "Available options:\n"
              "- 1: Low\n"
              "- 2: Medium\n"
              "- 3: High\n",
        ),

        BuildSection(
          title: "11. Local speaker",
          content:
              "Controls local speaker volume or mode. Ensures audio feedback for received signals\n"
              "Available options:\n"
              "- Auto: Automatically adjusts speaker volume based on environment.\n"
              "- On: Speaker is always on.\n"
              "- Off: Speaker is always off.\n",
        ),

        BuildSection(
          title: "12. Tx time limit",
          content:
              "Sets maximum transmission duration to prevent overheating or battery drain.\n"
              "Options range from 10 seconds to 5 minutes, with an 'Unlimited' option",
        ),
      ],
    );
  }

  @override
  String get label => "Radio settings guide";
}
