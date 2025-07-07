import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:flutter/material.dart';

import '../helpers/event_handler.dart';

class ChannelDrawer extends StatefulWidget {
  const ChannelDrawer({super.key});

  @override
  State<ChannelDrawer> createState() => _ChannelDrawerState();
}

class _ChannelDrawerState extends State<ChannelDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.2,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ValueListenableBuilder(
          valueListenable: statusNotifier,
          builder: (context, status, child) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: RadioExtract.radio.channels.length,
              itemBuilder: (BuildContext context, int index) {
                var channel = RadioExtract.radio.channels[index];
                return Card(
                  color: Colors.white,
                  child: Center(child: Text(channel.nameStr)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
