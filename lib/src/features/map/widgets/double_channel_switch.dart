import 'package:flutter/material.dart';
import 'package:radio/radio.dart';

import '../../../helpers/event_handler.dart';
import '../../../helpers/radio_extract.dart';
import '../../channel/repository/channel_repository.dart';
import '../../protect_app/screens/password_screen.dart';

class DoubleChannelSwitch extends StatefulWidget {
  const DoubleChannelSwitch({super.key});

  @override
  State<DoubleChannelSwitch> createState() => _DoubleChannelSwitchState();
}

class _DoubleChannelSwitchState extends State<DoubleChannelSwitch> {
  Status status = statusChangeNotifier.value;
  RadioSetting setting = settingChangeNotifier.value;

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

  dynamic statusListener, settingListener;

  void addListeners() {
    statusListener = () => {
      setState(() {
        status = statusChangeNotifier.value;
      }),
    };

    settingListener = () => {
      setState(() {
        setting = RadioExtract.radio.radioSetting;
      }),
    };

    statusChangeNotifier.addListener(statusListener);
    settingChangeNotifier.addListener(settingListener);
  }

  @override
  void initState() {
    addListeners();
    super.initState();
  }

  @override
  void dispose() {
    settingChangeNotifier.removeListener(settingListener);
    statusChangeNotifier.removeListener(statusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (setting.doubleChannel == 0) {
      return Center();
    }
    RfChannel chanA = getChannelById(RadioExtract.radio.radioSetting.channelA);
    RfChannel chanB = getChannelById(RadioExtract.radio.radioSetting.channelB);
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
              constraints: const BoxConstraints(minWidth: 150),
              padding: EdgeInsets.all(10),
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
                    color: status.currChId == chanA.channelId && status.isInRx
                        ? Colors.red
                        : Colors.grey,
                  ),
                  Text(
                    chanA.nameStr.isNotEmpty
                        ? chanA.nameStr
                        : chanA.rxFreq.toString(),
                    style: TextTheme.of(context).titleMedium,
                  ),
                  Icon(
                    Icons.arrow_upward_sharp,
                    color: status.currChId == chanA.channelId && status.isInTx
                        ? Colors.red
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
              constraints: const BoxConstraints(minWidth: 150),
              padding: EdgeInsets.all(10),
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
                    color: status.currChId == chanB.channelId && status.isInRx
                        ? Colors.red
                        : Colors.grey,
                  ),
                  Text(
                    chanA.nameStr.isNotEmpty
                        ? chanB.nameStr
                        : chanB.rxFreq.toString(),
                    style: TextTheme.of(context).titleMedium,
                  ),
                  Icon(
                    Icons.arrow_upward_sharp,
                    color: status.currChId == chanB.channelId && status.isInTx
                        ? Colors.red
                        : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
