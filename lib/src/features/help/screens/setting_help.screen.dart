import 'package:flutter/material.dart';
import '../constants/help.mixin.dart';
import 'app_setting_help.screen.dart';
import 'aprs_setting_help.screen.dart';
import 'drr_setting_help.screen.dart';
import 'radio_setting_help.screen.dart';

class SettingHelpScreen extends StatefulWidget with HelpPageMixin {
  const SettingHelpScreen({super.key});

  @override
  State<SettingHelpScreen> createState() => _SettingHelpScreenState();

  @override
  String get label => "Settings guide";
}

class _SettingHelpScreenState extends State<SettingHelpScreen> {
  int currentPageIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  final _settingHelpPages = [
    RadioSettingHelpScreen(),
    AprsSettingHelpScreen(),
    DrrSettingHelpScreen(),
    AppSettingHelpScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,

        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.radio),
            selectedIcon: Icon(
              Icons.radio,
              color: Theme.of(context).primaryColor,
            ),
            label: 'Radio',
          ),
          NavigationDestination(
            icon: Icon(Icons.share_location),
            selectedIcon: Icon(
              Icons.share_location,
              color: Theme.of(context).primaryColor,
            ),
            label: 'APRS',
          ),
          NavigationDestination(
            icon: Icon(Icons.warehouse_outlined),
            selectedIcon: Icon(
              Icons.warehouse_outlined,
              color: Theme.of(context).primaryColor,
            ),
            label: 'DRR',
          ),
          NavigationDestination(
            icon: Icon(Icons.app_settings_alt),
            selectedIcon: Icon(
              Icons.app_settings_alt,
              color: Theme.of(context).primaryColor,
            ),
            label: 'APP',
          ),
        ],
      ),
      body: _settingHelpPages[currentPageIndex],
    );
  }
}
