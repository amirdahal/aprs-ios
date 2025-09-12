import 'package:flutter/material.dart';

import '../constants/help.mixin.dart';

class AppSettingHelpScreen extends StatelessWidget with HelpPageMixin {
  const AppSettingHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  String get label => "App settings guide";
}
