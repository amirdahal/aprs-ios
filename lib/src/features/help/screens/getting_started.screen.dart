import 'package:flutter/material.dart';
import '../constants/help.mixin.dart';
import '../widgets/builder.widget.dart';

class GettingStartedHelpScreen extends StatelessWidget with HelpPageMixin {
  const GettingStartedHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        BuildSection(
          title: "Why configure standard settings?",
          content:
              "Once the app is successfully connected with the radio, "
              "it is recommended to configure the radio with a standard setting. "
              "This ensures the best operation of APRS messaging and communication.",
        ),

        const Divider(height: 32),

        BuildSection(
          title: "Step 1: Open Settings",
          content:
              "On the top of the main screen, tap the settings icon. "
              "This will open a new screen that contains all available settings.",
        ),

        const SizedBox(height: 32),

        BuildSection(
          // icon: Icons.grid_on_outlined,
          title: "Step 2: Radio Settings Tab",
          content:
              "The first tab is Radio Settings. Scroll down to the bottom "
              "of the screen until you see the button labeled 'Use default setting'.",
        ),

        const SizedBox(height: 32),

        BuildSection(
          title: "Step 3: Password Validation",
          content:
              "Tap 'Use default setting'. A password prompt will appear to prevent "
              "accidental misconfiguration.\n\n"
              "- Enter the password (default: 123456).\n"
              "- If the password is correct, the system will continue.",
        ),

        const SizedBox(height: 32),
        BuildSection(
          title: "Step 4: Apply Standard Setting",
          content:
              "On successful password validation, the standard setting is applied "
              "to the radio. This may take a few seconds to complete.",
        ),
      ],
    );
  }

  @override
  String get label => "Getting Started";
}
