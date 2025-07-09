import 'package:aprs/src/features/map/screens/map_screen.dart';
import 'package:aprs/src/helpers/event_handler.dart';
import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:aprs/src/features/channel/screens/channel_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        toolbarHeight: 60,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: ChannelScreen(),
      body: MapScreen(),
    );
  }
}
