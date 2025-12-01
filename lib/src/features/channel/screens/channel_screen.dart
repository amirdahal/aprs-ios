import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radio/radio.dart';
import 'package:drr_radio_tracker/src/features/channel/widgets/channel_tile.dart';
import 'package:drr_radio_tracker/src/helpers/radio_extract.dart';
import 'package:drr_radio_tracker/src/helpers/utils.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  final List<RfChannel> _channels = RadioExtract.radio.channels;
  final RadioSetting _radioSetting = RadioExtract.radio.radioSetting;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Building ChannelScreen with ${_channels.length} channels.');
      for (var channelId in [0, 1, 2]) {
        print(_channels[channelId].toMap());
      }
      print('Radio Setting: ${_radioSetting.toMap()}');
      print('APRS setting: ${RadioExtract.radio.aprsSetting.toMap()}');
    }
    return Drawer(
      semanticLabel: 'Channels',
      width: isLargeScreen ? 450 : MediaQuery.of(context).size.width / 1.2,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: false,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
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
