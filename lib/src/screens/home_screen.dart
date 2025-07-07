import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:aprs/src/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      drawer: ChannelDrawer(),
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
