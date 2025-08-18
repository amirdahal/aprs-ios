import 'package:flutter/material.dart';
import 'package:drr_radio_tracker/src/features/settings/app_setting/screens/app_setting_screen.dart';
import 'package:drr_radio_tracker/src/features/settings/aprs_setting/screens/aprs_setting_screen.dart';
import 'package:drr_radio_tracker/src/features/settings/drr_setting/screens/drr_setting_screen.dart';
import 'package:drr_radio_tracker/src/features/settings/radio_setting/screens/radio_setting_screen.dart';
import 'package:drr_radio_tracker/src/helpers/my_position.util.dart';

class SettingLayout extends StatefulWidget {
  const SettingLayout({super.key});

  @override
  State<SettingLayout> createState() => _SettingLayoutState();
}

class _SettingLayoutState extends State<SettingLayout> {
  int currentPageIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  final _pages = [
    RadioSettingScreen(),
    AprsSettingScreen(),
    DrrSettingScreen(),
    AppSettingScreen(),
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
          if (enablePositionSharing)
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
      body: _pages[currentPageIndex],
    );
  }
}
