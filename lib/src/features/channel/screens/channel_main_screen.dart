import 'package:aprs/src/features/channel/widgets/channel_tile.dart';
import 'package:aprs/src/helpers/radio_extract.dart' show RadioExtract;
import 'package:flutter/material.dart';
import 'package:radio/radio.dart';

class ChannelMainScreen extends StatefulWidget {
  const ChannelMainScreen({super.key});

  @override
  State<ChannelMainScreen> createState() => _ChannelMainScreenState();
}

class _ChannelMainScreenState extends State<ChannelMainScreen> {
  final List<RfChannel> _channels = RadioExtract.radio.channels;
  final RadioSetting _radioSetting = RadioExtract.radio.radioSetting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Channels')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemCount: _channels.length,
          itemBuilder: (BuildContext context, int index) {
            RfChannel channel = _channels[index];
            return ChannelTile(channel: channel, radioSetting: _radioSetting);
          },
        ),
      ),
    );
  }
}
