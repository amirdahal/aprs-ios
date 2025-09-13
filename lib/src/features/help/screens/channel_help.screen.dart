import 'package:drr_radio_tracker/src/features/help/constants/help.mixin.dart';
import 'package:drr_radio_tracker/src/features/help/widgets/builder.widget.dart';
import 'package:flutter/material.dart';

class ChannelHelpScreen extends StatelessWidget with HelpPageMixin {
  const ChannelHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        BuildSection(
          title: "Channels",
          content:
              "From the home screen, click on Menu (☰) to see and configure channels.\n"
              "If your channels don't look similar as in below image, follow the 'Getting started' guide.",
        ),
        BuildImage(
          imageName: "channel_list.png",
          caption: "Configured channels list",
        ),

        const SizedBox(height: 16),

        BuildSection(
          title: "Channel options",
          content:
              "To take an action against any channel, long press on the channel item from this list.\n"
              "Available options:\n"
              " - Set Channel A\n"
              " - Set Channel B\n"
              " - Details: Tap to see more about a channel",
        ),
        Text(
          "A radio can have 2 channels to quickly switch between. When we perform 'Use default setting', AUD channel(Analog voice) channel is set as channel A and APRS channel (Digital APRS) channel is set as channel B.\n"
          "However it is recommended not to change these settings unless you know what you're doing",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        BuildImage(imageName: "channel_option.png", caption: "Channel options"),

        const SizedBox(height: 16),

        BuildSection(
          title: "Channel detail",
          content:
              "This screen display the available configuration options for each channel",
        ),
        BuildImage(imageName: "channel_detail.png", caption: "Channel detail"),

        const SizedBox(height: 16),

        BuildSection(
          title: "Update guide",
          content:
              "Here's what each field in the channel detail interface refers to.",
        ),

        const Divider(),

        BuildSection(
          title: "1. Name",
          content:
              "The human-readable name for the channel (e.g., 'APRS'), up to 8 characters",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "2. Rx Frequency ",
          content:
              "It's the receive frequency in MHz, often offset from transmit for full-duplex (e.g., transmit on 146.520, receive on 146.120 for a repeater)",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "3. Tx Frequency",
          content:
              "It's the transmit frequency in MHz (e.g., 144.390 for APRS), the exact spot on the band where your signal launches.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "4. Mode",
          content:
              "his configures the receive modulation type, allowing the radio to decode incoming signals in FM, AM, or DMR.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "5. Transmit CTCSS/DCS",
          content:
              "This is the transmit sub-audible tone or code—either a CTCSS frequency (float, e.g., 88.5 Hz for squelch access), a DCS code (Digital-Coded Squelch, e.g., DCS(23)), or null (no tone).",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "6. Receive CTCSS/DCS",
          content:
              "The receive sub-audible tone or code, matching transmit for selective squelch—float for CTCSS, DCS object for digital codes, or null for open receive.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "7. Bandwidth",
          content:
              "Sets the channel bandwidth (Narrow = 12.5 kHz for tight spacing, Wide = 25 kHz for broader signals).",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "8. Power",
          content: "Set transmit power to Low, Medium or High.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "9. Disable transmit",
          content: "Disables transmission entirely, locking the PTT.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "10. Mute",
          content: "Mutes audio output, suppressing received signals.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "11. Scan",
          content:
              "it enables scanning across channels or frequencies, pausing on active signals.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "12. Talk around",
          content:
              "Bypasses repeater offsets for direct simplex communication, 'talking around' the repeater.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "13. De-emphasis",
          content:
              "disables pre-emphasis/de-emphasis filtering, which boosts high frequencies on transmit and cuts them on receive for consistent audio.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "14. Sign",
          content:
              "Enables signaling tones (e.g., Roger beep or end-of-transmission tone) to indicate PTT release.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "15. Fixed frequency",
          content:
              "Locks the frequency, preventing accidental changes during operation.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "16. Fixed Tx power",
          content: "Locks transmit power, ensuring consistent output.",
        ),
        const SizedBox(height: 16),

        BuildSection(
          title: "17. Fixed bandwidth",
          content:
              "Locks the bandwidth setting, avoiding mismatches in repeaters.",
        ),
        const SizedBox(height: 16),

        Text(
          "* After applying your changes, click the 'Save channel' button.\n"
          "* Something didn't work or the radio broke? Follow the 'Getting started' guide.",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  @override
  String get label => "Channel guide";
}
