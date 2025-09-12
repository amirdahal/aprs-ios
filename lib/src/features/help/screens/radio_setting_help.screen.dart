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

        const SizedBox(height: 16),

        BuildSection(
          title: "13. Tx hold time",
          content:
              "Sets delay (seconds) before releasing PTT after transmission. Off allows immediate PTT release, suitable for rapid APRS packets\n"
              "Options range from 0.1 second to 1 minute, with an 'Off' option.",
        ),

        const SizedBox(height: 16),

        BuildSection(
          title: "14. Headphone mode",
          content:
              "Configures Advanced Generic Hands-Free Profile (AGHFP) mode for Bluetooth audio/call functionality.\n"
              "Available options:\n"
              "- Voice mode\n"
              "- Call mode",
        ),

        const SizedBox(height: 16),

        BuildSection(
          title: "15. Keep headset connected",
          content:
              ": Maintains a persistent Bluetooth AGHFP connection. Disable to reduce power consumption for Bluetooth.",
        ),

        const SizedBox(height: 16),
        BuildSection(
          title: "16. Adaptive response",
          content:
              "Enables adaptive audio processing for dynamic environments.",
        ),

        const SizedBox(height: 16),

        BuildSection(
          title: "17. Tone",
          content: "CTCSS/DCS tone squelch for selective communication",
        ),

        const SizedBox(height: 16),

        BuildSection(
          title: "18. Automatic shutdown",
          content: "Sets auto power-off timer (e.g., minutes).",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "19. APRS channel",
          content:
              "Sets the APRS channel. By default, the APRS channel is configured in channel 29. Recommended not to change",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "20. Wired microphone speaker",
          content: "Configures headset or external speaker.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "21. Signaling preamble",
          content: "Enables leading sync bits for digital modes",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "22. Digital mute",
          content:
              "Enable digital mute, allowing digital signals to not be heard.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "23. Pairing at power on",
          content: "Enables automatic Bluetooth pairing mode at power-on.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "25. Channel data lock",
          content: "Locks channel data to prevent changes.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "26. Wx mode",
          content:
              "Configures weather (NOAA) mode."
              "Available options:\n"
              "- Off\n-Monitor\n-Alert",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "26. Wx channel",
          content: "Selects NOAA weather channel. Choose from given options.",
        ),
        const SizedBox(height: 20),

        Text(
          "*Note: The default settings applied in the 'Getting started' section enables the best suited configuration for your radio. Do not change any setting unless you know what you're doing. Always go back to radio settings tab and click on 'Use default setting' if things don't work as expected.",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  @override
  String get label => "Radio settings guide";
}
