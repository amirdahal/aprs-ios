import 'package:drr_radio_tracker/src/features/help/constants/help.mixin.dart';
import 'package:drr_radio_tracker/src/features/help/widgets/builder.widget.dart';
import 'package:flutter/material.dart';

class MainScreenHelpPage extends StatelessWidget with HelpPageMixin {
  const MainScreenHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        BuildImage(
          imageName: 'app_home_screen.png',
          caption: "Main app screen",
        ),

        const SizedBox(height: 16),

        BuildSection(
          // icon: LucideIcons.map,
          title: "Map View",
          content:
              "The main part of the screen shows the **offline map of the Philippines**. "
              "This map can display different layers:\n\n"
              "- APRS Layer: Shows positions of peers. Tap on the position marker to see details.\n"
              "- GIS Layer: Displays geographic information.\n"
              "- Evacuation Centers Layer: Highlights evacuation centers for crisis situations. Tap on the markers to share position or follow navigation.\n\n"
              "You can zoom in/out using the green buttons on the right.",
          // image: "assets/help/main_map.png",
        ),

        const Divider(height: 32),

        BuildSection(
          // icon: LucideIcons.radio,
          title: "Channel Controls",
          content:
              "At the top-left of the map, you’ll see the channel controls. This is only visible if your radio is configured to be used in Dual Channel mode (recommeded).\n\n"
              "- AUD/AUD_REP: Audio channel\n"
              "- APRS: APRS channel\n\n"
              "Tap on the boxes to switch between channels or adjust settings.\n\n"
              "If this is not visible, follow the `Getting started` section.",

          // image: "assets/help/channel_controls.png",
        ),

        const Divider(height: 32),

        BuildSection(
          // icon: LucideIcons.layoutDashboard,
          title: "Top Bar",
          content:
              "The top green bar contains:\n\n"
              "- Menu (☰): Opens the side menu to see and configure channels.\n"
              "- Connected Radio Name (e.g., VR-N76)\n"
              "- Battery Indicator\n"
              "- Messaging Icon: Access APRS messages.\n"
              "- Log Icon: View stored logs.\n"
              "- Settings Icon ⚙️: Configure radio and app settings.\n"
              "- Power Icon ⏻: Disconnect or exit.",
          // image: "assets/help/top_bar.png",
        ),

        const Divider(height: 32),

        BuildSection(
          // icon: LucideIcons.settings,
          title: "Right-side Controls",
          content:
              "On the right side of the map:\n\n"
              "- Position Icon: Show/hide my position.\n"
              "- Green Magnifying Glass: Zoom controls.\n",
          // "- **Blue Arrow Icon**: Re-center the map.",
          // image: "assets/help/right_controls.png",
        ),
        // BuildImage(imageName: "", caption: )
      ],
    );
  }

  @override
  String get label => "Understanding map screen";

  // Widget _buildSection({
  //   required IconData icon,
  //   required String title,
  //   required String content,
  //   String? image,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Icon(icon, size: 26, color: Colors.blueAccent),
  //           const SizedBox(width: 12),
  //           Expanded(
  //             child: Text(
  //               title,
  //               style: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 8),
  //       Text(
  //         content,
  //         style: const TextStyle(fontSize: 15, height: 1.5),
  //       ),
  //       if (image != null) ...[
  //         const SizedBox(height: 12),
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(8),
  //           child: Image.asset(image),
  //         ),
  //       ],
  //     ],
  //   );
  // }
}
