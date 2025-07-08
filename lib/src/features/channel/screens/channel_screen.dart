import 'package:aprs/src/helpers/event_handler.dart';
import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:aprs/src/features/channel/widgets/channel_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radio/radio.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  List<RfChannel> _channels = RadioExtract.radio.channels;

  @override
  void initState() {
    if (mounted) {
      setState(() {
        _channels = RadioExtract.radio.channels;
        if (kDebugMode) {
          print("Initial channels loaded");
        }
      });

      // channels.addListener(() {
      //   setState(() {
      //     _channels = channels.value;
      //   });
      //   if (kDebugMode) {
      //     print("State channels loaded");
      //   }
      // });

      settingChangeNotifier.addListener(() {
        setState(() {
          _channels = RadioExtract.radio.channels;
        });
        if (kDebugMode) {
          print("settings channels loaded");
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.2,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: _channels.length,
          itemBuilder: (BuildContext context, int index) {
            RfChannel channel = _channels[index];
            return ChannelTile(channel: channel);
          },
        ),
      ),
    );
  }
}
