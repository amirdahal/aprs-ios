import 'package:drr_radio_tracker/src/features/help/screens/connectivity.screen.dart';
import 'package:drr_radio_tracker/src/features/help/screens/getting_started.screen.dart';
import 'package:drr_radio_tracker/src/features/help/screens/log_helper.screen.dart';
import 'package:drr_radio_tracker/src/features/help/screens/main_app_help.screen.dart';
import 'package:drr_radio_tracker/src/features/help/screens/messaging_help.screen.dart';
import 'package:flutter/material.dart';

import '../screens/home.screen.dart';

class HelpMenuItems {
  String label;
  IconData iconData;
  Widget helpScreen;

  HelpMenuItems({
    required this.label,
    required this.iconData,
    required this.helpScreen,
  });
}

final List<HelpMenuItems> helpMenuItems = [
  HelpMenuItems(
    label: 'About the app',
    iconData: Icons.info,
    helpScreen: HelpHome(),
  ),
  HelpMenuItems(
    label: 'Connectivity',
    iconData: Icons.bluetooth,
    helpScreen: ConnectivityHelpScreen(),
  ),
  HelpMenuItems(
    label: 'Getting started',
    iconData: Icons.stacked_line_chart_rounded,
    helpScreen: GettingStartedHelpScreen(),
  ),
  HelpMenuItems(
    label: 'Understand map screen',
    iconData: Icons.map_outlined,
    helpScreen: MainScreenHelpPage(),
  ),
  HelpMenuItems(
    label: 'APRS messaging',
    iconData: Icons.message_outlined,
    helpScreen: MessagingHelpScreen(),
  ),
  HelpMenuItems(
    label: "Logging and tracking",
    iconData: Icons.list_alt_outlined,
    helpScreen: LogHelperScreen(),
  ),
];
