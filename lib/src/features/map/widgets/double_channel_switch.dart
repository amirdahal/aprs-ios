import 'package:flutter/material.dart';
import 'package:radio/radio.dart';

import '../../../helpers/event_handler.dart';
import '../../../helpers/radio_extract.dart';
import '../../channel/repository/channel_repository.dart';
import '../../protect_app/screens/password_screen.dart';

class DoubleChannelSwitch extends StatelessWidget {
  const DoubleChannelSwitch({super.key});

  RfChannel getChannelById(int id) {
    return RadioExtract.radio.channels.firstWhere(
      (channel) => channel.channelId == id,
    );
  }

  void updateDoubleChannel(int doubleChannel) {
    ChannelRepository.updateRadioSettings(
      scan: RadioExtract.radio.radioSetting.scan,
      doubleChannel: doubleChannel,
      powerSavingMode: RadioExtract.radio.radioSetting.powerSavingMode,
      squelchLevel: RadioExtract.radio.radioSetting.squelchLevel,
      audioRelay: RadioExtract.radio.radioSetting.autoRelayEn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: statusChangeNotifier,
      builder: (context, status, child) {
        if (status.doubleChannel == ChannelType.OFF) {
          return const Placeholder();
        }
        RfChannel chanA = getChannelById(
          RadioExtract.radio.radioSetting.channelA,
        );
        RfChannel chanB = getChannelById(
          RadioExtract.radio.radioSetting.channelB,
        );
        return Positioned(
          top: 40,
          left: 40,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordScreen(
                        onValidate: () async => updateDoubleChannel(1),
                        actionDescription: 'Validate to take action',
                      ),
                    ),
                  );
                  // updateDoubleChannel(1);
                },
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 150,
                    minHeight: 60,
                  ),
                  decoration: BoxDecoration(
                    color: status.doubleChannel.value == 1
                        ? Colors.lightGreen
                        : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.arrow_downward_sharp,
                        color:
                            status.currChId == chanA.channelId && status.isInRx
                            ? Colors.white
                            : Colors.grey,
                      ),
                      Text(
                        chanA.nameStr.isNotEmpty
                            ? chanA.nameStr
                            : chanA.rxFreq.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.arrow_upward_sharp,
                        color:
                            status.currChId == chanA.channelId && status.isInTx
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordScreen(
                        onValidate: () async => updateDoubleChannel(2),
                        actionDescription: 'Validate to take action',
                      ),
                    ),
                  );
                  // updateDoubleChannel(2);
                },
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 150,
                    minHeight: 60,
                  ),
                  decoration: BoxDecoration(
                    color: status.doubleChannel.value == 2
                        ? Colors.lightGreen
                        : Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.arrow_downward_sharp,
                        color:
                            status.currChId == chanB.channelId && status.isInRx
                            ? Colors.white
                            : Colors.grey,
                      ),
                      Text(
                        chanA.nameStr.isNotEmpty
                            ? chanB.nameStr
                            : chanB.rxFreq.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.arrow_upward_sharp,
                        color:
                            status.currChId == chanB.channelId && status.isInTx
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
