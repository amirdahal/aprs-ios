import 'package:flutter/material.dart';
import 'package:radio/radio.dart';
import 'package:smart_rf/src/features/channel/repository/channel_repository.dart';
import 'package:smart_rf/src/features/protect_app/screens/password_screen.dart';
import 'package:smart_rf/src/helpers/event_handler.dart';
import 'package:smart_rf/src/helpers/radio_extract.dart';
import 'package:smart_rf/src/helpers/utils.dart';

import '../screens/channel_detail_screen.dart';

class ChannelTile extends StatefulWidget {
  final RfChannel channel;
  final RadioSetting radioSetting;

  const ChannelTile({
    super.key,
    required this.channel,
    required this.radioSetting,
  });

  @override
  State<ChannelTile> createState() => _ChannelTileState();
}

class _ChannelTileState extends State<ChannelTile> {
  Status status = RadioExtract.radio.status;

  dynamic statusListener;

  get radioSetting => widget.radioSetting;

  void addStatusListener() {
    statusListener = () => {
      setState(() {
        status = statusChangeNotifier.value;
      }),
    };

    statusChangeNotifier.addListener(statusListener);
  }

  void _channelAction() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Action on channel ${widget.channel.channelId}'),
          content: null,
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                bool isValid = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PasswordScreen(
                      actionDescription: 'Validate to complete the action',
                    ),
                  ),
                );
                if (isValid) {
                  // ReplyStatus status =
                  await ChannelRepository.setChannelAorB(
                    option: ChannelOption.channelA,
                    channelId: widget.channel.channelId,
                  );
                }
              },
              child: const Text('Set Channel A'),
            ),
            TextButton(
              onPressed: () async {
                bool isValid = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PasswordScreen(
                      actionDescription: 'Validate to complete the action',
                    ),
                  ),
                );
                if (isValid) {
                  // ReplyStatus status =
                  await ChannelRepository.setChannelAorB(
                    option: ChannelOption.channelB,
                    channelId: widget.channel.channelId,
                  );
                }
              },
              child: const Text('Set Channel B'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChannelDetailScreen(channel: widget.channel),
                  ),
                );
              },
              child: const Text('Details'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    addStatusListener();
    super.initState();
  }

  @override
  void dispose() {
    statusChangeNotifier.removeListener(statusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color boxColor = Colors.white;
    if (radioSetting.channelA == widget.channel.channelId) {
      boxColor = Colors.green.shade400;
    }
    if (radioSetting.doubleChannel > 0) {
      if (radioSetting.channelB == widget.channel.channelId) {
        boxColor = Colors.green.shade400;
      }
    }
    return GestureDetector(
      onLongPress: _channelAction,
      onTap: isLargeScreen ? _channelAction : null,
      child: Card(
        color: boxColor,
        shadowColor: boxColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.channel.nameStr.isNotEmpty)
              Text(
                widget.channel.nameStr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            Text(
              "Rx: ${widget.channel.rxFreq.toString()}",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            Text(
              "Tx: ${widget.channel.txFreq.toString()}",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            // if (status.currChId == widget.channel.channelId)
            //   if (status.isInRx)
            //     const Icon(
            //       Icons.arrow_circle_down_outlined,
            //       color: Colors.green,
            //       size: 40,
            //     ),
            // if (status.currChId == widget.channel.channelId)
            //   if (status.isInTx)
            //     const Icon(
            //       Icons.arrow_circle_up_outlined,
            //       color: Colors.red,
            //       size: 40,
            //     ),
          ],
        ),
      ),
    );
  }
}
