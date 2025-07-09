import 'package:aprs/src/features/settings/aprs_setting/screens/aprs_setting_screen.dart';
import 'package:aprs/src/features/settings/drr_setting/screens/drr_setting_screen.dart';
import 'package:aprs/src/features/settings/radio_setting/screens/radio_setting_screen.dart';
import 'package:flutter/material.dart';

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
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.radio), label: 'Radio'),
          NavigationDestination(
            icon: Icon(Icons.share_location),
            label: 'APRS',
          ),
          NavigationDestination(
            icon: Icon(Icons.warehouse_outlined),
            label: 'DRR',
          ),
        ],
      ),
      body: _pages[currentPageIndex],
    );
  }
}
