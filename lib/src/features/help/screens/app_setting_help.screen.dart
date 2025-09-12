import 'package:drr_radio_tracker/src/features/help/widgets/builder.widget.dart';
import 'package:flutter/material.dart';

import '../constants/help.mixin.dart';

class AppSettingHelpScreen extends StatelessWidget with HelpPageMixin {
  const AppSettingHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        BuildSection(
          title: "App settings",
          content:
              "This setting allows you to update your validation password.\n"
              "A validation password is required to prevent accidental misconfigurations by random touches.",
        ),

        const Divider(height: 16),

        BuildSection(title: "Updating password", content: "In the provided form, enter a new password and save the setting.\n" "The default password is '123456'.")
      ],
    );
  }

  @override
  String get label => "App settings guide";
}
