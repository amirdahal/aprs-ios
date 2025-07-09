import 'package:aprs/src/features/aprs_log/screens/aprs_log_screen.dart';
import 'package:aprs/src/features/map/screens/map_screen.dart';
import 'package:aprs/src/features/settings/setting_layout.dart';
import 'package:aprs/src/helpers/event_handler.dart';
import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:aprs/src/features/channel/screens/channel_screen.dart';
import 'package:flutter/material.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  void addEventHandler() async {
    await RadioExtract.radio.addEventHandler(radioEventsHandler);
  }

  @override
  void initState() {
    if (mounted) {
      addEventHandler();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingLayout()),
              );
            },
            icon: Icon(Icons.settings),
            tooltip: 'Settings',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AprsLogScreen()),
              );
            },
            icon: Icon(Icons.list_alt),
            tooltip: 'Aprs logs',
          ),
        ],
      ),
      drawer: ChannelScreen(),
      body: MapScreen(),
    );
  }
}
