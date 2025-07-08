import 'package:aprs/src/features/channel/repository/channel_repository.dart';
import 'package:aprs/src/features/protect_app/screens/password_screen.dart';
import 'package:aprs/src/helpers/event_handler.dart';
import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:flutter/material.dart';
import 'package:radio/radio.dart';

import '../screens/channel_detail_screen.dart';

class ChannelTile extends StatelessWidget {
  final RfChannel channel;

  ChannelTile({super.key, required this.channel});

  // CustomEvents events = CustomEvents.instance;

  // void toastError() {
  //   showToast(
  //     context: context,
  //     type: ToastificationType.error,
  //     title: 'Set Channel',
  //     description: "Setting channel A of B failed",
  //   );
  // }
  //
  // void closePopup() {
  //   Navigator.of(context).pop();
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: statusChangeNotifier,
      builder: (context, status, child) {
        RadioSetting radioSetting = RadioExtract.radio.radioSetting;
        Color boxColor = Colors.white;
        if (radioSetting.channelA == channel.channelId) {
          boxColor = Colors.green.shade400;
        }
        if (radioSetting.doubleChannel > 0) {
          if (radioSetting.channelB == channel.channelId) {
            boxColor = Colors.green.shade400;
          }
        }
        return GestureDetector(
          onLongPress: () {
            showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Action on channel ${channel.channelId}'),
                  content: null,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        bool isValid = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PasswordScreen(
                              actionDescription:
                                  'Validate to complete the action',
                            ),
                          ),
                        );
                        if (isValid) {
                          // ReplyStatus status =
                          await ChannelRepository.setChannelAorB(
                            option: ChannelOption.channelA,
                            channelId: channel.channelId,
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
                              actionDescription:
                                  'Validate to complete the action',
                            ),
                          ),
                        );
                        if (isValid) {
                          // ReplyStatus status =
                          await ChannelRepository.setChannelAorB(
                            option: ChannelOption.channelB,
                            channelId: channel.channelId,
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
                                ChannelDetailScreen(channel: channel),
                          ),
                        );
                      },
                      child: const Text('Details'),
                    ),
                  ],
                );
              },
            );
          },
          child: Card(
            color: boxColor,
            shadowColor: boxColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (channel.nameStr.isNotEmpty)
                  Text(
                    channel.nameStr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                Text(
                  "${channel.rxFreq.toString()} / ${channel.txFreq.toString()}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (status.currChId == channel.channelId)
                  if (status.isInRx)
                    const Icon(
                      Icons.arrow_circle_down_outlined,
                      color: Colors.green,
                      size: 40,
                    ),
                if (status.currChId == channel.channelId)
                  if (status.isInTx)
                    const Icon(
                      Icons.arrow_circle_up_outlined,
                      color: Colors.red,
                      size: 40,
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
