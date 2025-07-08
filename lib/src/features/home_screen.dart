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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(RadioExtract.radio.deviceInfo.toMap().toString()),
              Text(RadioExtract.radio.radioSetting.toMap().toString()),
              Text(RadioExtract.radio.aprsSetting.toMap().toString()),
              for (var channel in RadioExtract.radio.channels)
                Text(channel.toMap().toString()),
            ],
          ),
        ),
      ),
    );
  }
}
