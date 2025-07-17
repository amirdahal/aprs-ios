import 'package:aprs/src/features/protect_app/screens/password_screen.dart';
import 'package:aprs/src/features/settings/repository/constants.dart';
import 'package:aprs/src/features/settings/repository/setting.repository.dart';
import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:aprs/src/widgets/buttons.dart';
import 'package:aprs/src/widgets/dropdown.dart';
import 'package:aprs/src/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:radio/radio.dart';
import 'package:string_validator/string_validator.dart';

class RadioSettingScreen extends StatefulWidget {
  const RadioSettingScreen({super.key});

  @override
  State<RadioSettingScreen> createState() => _RadioSettingScreenState();
}

class _RadioSettingScreenState extends State<RadioSettingScreen> {
  late RadioSetting currentSetting;

  bool scan = false;
  bool powerSavingMode = false;
  int squelchLevel = 1;
  int doubleChannel = 0;
  int sliderPreview = 1;
  bool audioRelay = false;
  int channelA = 0;
  int channelB = 0;
  int enableBTMic = 0;
  bool tailElimination = false;
  bool autoPowerOn = false;
  int micGain = 0;
  int btMicGain = 0;
  int txTimeLimit = 0;
  int txHoldTime = 0;
  int localSpeaker = 0;
  int headphoneMode = 0;
  bool keepHeadphoneConnected = false;
  bool adaptiveResponse = false;
  bool tone = false;
  int autoPowerOff = 0;
  int autoShareLocationChannel = 0;
  int wiredMicrophoneSpeaker = 0;

  bool editingEnabled = false;

  bool showAdvancedSetting = false;

  void close({String content = 'Radio setting updated.'}) {
    showSnackBar(context: context, content: content);
  }

  Future<void> _updateRadioSetting() async {
    RadioSetting newSetting = RadioExtract.radio.radioSetting.copyWith();
    newSetting.scan = scan;
    newSetting.doubleChannel = doubleChannel;
    newSetting.powerSavingMode = powerSavingMode;
    newSetting.squelchLevel = squelchLevel;
    newSetting.autoRelayEn = audioRelay;
    await RadioExtract.radio.setRadioSettings(newSetting);
    setState(() {
      editingEnabled = false;
    });
    close();
  }

  void populateSettings() {
    currentSetting = RadioExtract.radio.radioSetting;
    print(currentSetting.toMap());
    setState(() {
      scan = currentSetting.scan;
      powerSavingMode = currentSetting.powerSavingMode;
      squelchLevel = currentSetting.squelchLevel;
      audioRelay = currentSetting.autoRelayEn;
      doubleChannel = currentSetting.doubleChannel;
      sliderPreview = squelchLevel;
      channelA = currentSetting.channelA;
      channelB = currentSetting.channelB;
      enableBTMic = currentSetting.aghfpCallMode;
      tailElimination = currentSetting.tailElim;
      autoPowerOn = currentSetting.autoPowerOn;
      micGain = currentSetting.micGain;
      btMicGain = currentSetting.btMicGain;
      txTimeLimit = currentSetting.txTimeLimit;
      txHoldTime = currentSetting.txHoldTime;
      localSpeaker = currentSetting.localSpeaker;
      headphoneMode = currentSetting.aghfpCallMode;
      keepHeadphoneConnected = currentSetting.keepAghfpLink;
      adaptiveResponse = currentSetting.adaptiveResponse;
      tone = !currentSetting.disTone;
      autoPowerOff = currentSetting.autoPowerOff;
      autoShareLocationChannel = currentSetting.autoShareLocCh;
      wiredMicrophoneSpeaker = currentSetting.hmSpeaker;
    });
  }

  @override
  void initState() {
    populateSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Radio Settings"),
        actions: [
          if (!editingEnabled)
            IconButton(
              onPressed: () async {
                bool isValidated = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PasswordScreen(
                      actionDescription:
                          'Validate to enable editing the radio settings',
                    ),
                  ),
                );
                if (isValidated) {
                  setState(() {
                    editingEnabled = true;
                  });
                }
              },
              icon: Icon(Icons.edit),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          spacing: 20,
          children: [
            Column(
              spacing: 20,
              children: [
                ListTile(
                  title: const Text("Repeater mode"),
                  trailing: Switch(
                    value: audioRelay,
                    onChanged: editingEnabled
                        ? (bool value) {
                            setState(() {
                              audioRelay = value;
                            });
                          }
                        : null,
                  ),
                ),
                ListTile(
                  title: const Text("Scan"),
                  trailing: Switch(
                    value: scan,
                    onChanged: editingEnabled
                        ? (bool value) {
                            setState(() {
                              scan = value;
                            });
                          }
                        : null,
                  ),
                ),
                ListTile(
                  title: DropDown(
                    onChanged: editingEnabled
                        ? (val) {
                            setState(() {
                              doubleChannel = doubleChanOptions[val]!;
                            });
                          }
                        : null,
                    options: doubleChanOptions.keys.toList(),
                    selectedValue: doubleChanOptions.entries
                        .firstWhere((entry) => entry.value == doubleChannel)
                        .key,
                    label: 'Double channel',
                  ),
                ),
                ListTile(
                  title: const Text("Power saving mode"),
                  trailing: Switch(
                    value: powerSavingMode,
                    onChanged: editingEnabled
                        ? (bool value) {
                            setState(() {
                              powerSavingMode = value;
                            });
                          }
                        : null,
                  ),
                ),
                ListTile(
                  title: const Text("Squelch level"),
                  subtitle: Slider.adaptive(
                    label: sliderPreview.toInt().toString(),
                    value: sliderPreview.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 10,
                    onChangeEnd: (double value) {
                      setState(() {
                        squelchLevel = value.toInt();
                      });
                    },
                    onChanged: editingEnabled
                        ? (double value) {
                            sliderPreview = value.toInt();
                            setState(() {});
                          }
                        : null,
                  ),
                ),
                ListTile(
                  title: DropDown(
                    onChanged: (value) {
                      int id = int.parse(value!.trim().split('Channel ')[1]);
                      setState(() {
                        channelA = id;
                      });
                    },
                    options: channelOptions,
                    selectedValue: 'Channel $channelA',
                    label: 'Channel A',
                  ),
                ),
                ListTile(
                  title: DropDown(
                    onChanged: (value) {
                      int id = int.parse(value!.trim().split('Channel ')[1]);
                      setState(() {
                        channelB = id;
                      });
                    },
                    options: channelOptions,
                    selectedValue: 'Channel $channelB',
                    label: 'Channel B',
                  ),
                ),
                ListTile(
                  title: const Text("Enable BT mic"),
                  trailing: Switch(
                    value: enableBTMic > 0,
                    onChanged: editingEnabled
                        ? (bool value) {
                            setState(() {
                              enableBTMic = value ? 1 : 0;
                            });
                          }
                        : null,
                  ),
                ),
                ListTile(
                  title: const Text("Tail elimination"),
                  trailing: Switch(
                    value: tailElimination,
                    onChanged: editingEnabled
                        ? (bool value) {
                            setState(() {
                              tailElimination = value;
                            });
                          }
                        : null,
                  ),
                ),
                ListTile(
                  title: const Text("Auto power on"),
                  trailing: Switch(
                    value: autoPowerOn,
                    onChanged: editingEnabled
                        ? (bool value) {
                            setState(() {
                              autoPowerOn = value;
                            });
                          }
                        : null,
                  ),
                ),
                ListTile(
                  title: DropDown(
                    onChanged: (value) {
                      setState(() {
                        micGain = micGainOptions[value]!;
                      });
                    },
                    options: micGainOptions.keys.toList(),
                    selectedValue: micGainOptions.entries
                        .firstWhere((entry) => entry.value == micGain)
                        .key,
                    label: 'Mic gain',
                  ),
                ),
                ListTile(
                  title: DropDown(
                    onChanged: (value) {
                      setState(() {
                        btMicGain = btMicGainOptions[value]!;
                      });
                    },
                    options: btMicGainOptions.keys.toList(),
                    selectedValue: btMicGainOptions.entries
                        .firstWhere((entry) => entry.value == btMicGain)
                        .key,
                    label: 'Bluetooth mic gain',
                  ),
                ),
                ListTile(
                  title: DropDown(
                    onChanged: (value) {
                      setState(() {
                        localSpeaker = localSpeakerOptions[value]!;
                      });
                    },
                    options: localSpeakerOptions.keys.toList(),
                    selectedValue: localSpeakerOptions.entries
                        .firstWhere((entry) => entry.value == localSpeaker)
                        .key,
                    label: 'Local speaker',
                  ),
                ),
                ListTile(
                  title: DropDown(
                    onChanged: (value) {
                      int val = 0;
                      if (value!.trim().equals('Unlimited')) {
                        val = 0;
                      } else {
                        val = int.parse(value.split(' ')[0]);
                      }
                      setState(() {
                        txTimeLimit = (val / 10).toInt();
                      });
                    },
                    options: txTimeLimitOptions,
                    selectedValue: txTimeLimit == 0
                        ? 'Unlimited'
                        : '${txTimeLimit * 10} seconds',
                    label: 'Tx time limit',
                  ),
                ),
                ListTile(
                  title: DropDown(
                    onChanged: (value) {
                      int val = 0;
                      if (value!.trim().equals('Off')) {
                        val = 0;
                      } else {
                        val = (double.parse(value.split(' ')[0]) * 10).toInt();
                      }
                      txHoldTime = val;
                    },
                    options: txHoldTimeOptions,
                    selectedValue: txHoldTime == 0
                        ? 'Off'
                        : '${(txHoldTime / 10).toStringAsFixed(1)} second',
                    label: 'Tx hold time',
                  ),
                ),
                ListTile(
                  title: DropDown(
                    onChanged: (value) {
                      setState(() {
                        headphoneMode = headphoneModeOptions[value]!;
                      });
                    },
                    options: headphoneModeOptions.keys.toList(),
                    selectedValue: headphoneModeOptions.entries
                        .firstWhere((entry) => entry.value == headphoneMode)
                        .key,
                    label: 'Headphone mode',
                  ),
                ),
                ListTile(
                  title: const Text("Keep headphone connected"),
                  trailing: Switch(
                    value: keepHeadphoneConnected,
                    onChanged: editingEnabled
                        ? (bool value) {
                            setState(() {
                              keepHeadphoneConnected = value;
                            });
                          }
                        : null,
                  ),
                ),
                ListTile(
                  title: const Text("Adaptive response"),
                  trailing: Switch(
                    value: adaptiveResponse,
                    onChanged: editingEnabled
                        ? (bool value) {
                            setState(() {
                              adaptiveResponse = value;
                            });
                          }
                        : null,
                  ),
                ),
                ListTile(
                  title: const Text("Tone"),
                  trailing: Switch(
                    value: tone,
                    onChanged: editingEnabled
                        ? (bool value) {
                            setState(() {
                              tone = value;
                            });
                          }
                        : null,
                  ),
                ),
                ListTile(
                  title: DropDown(
                    onChanged: (value) {
                      setState(() {
                        autoPowerOff = autoPowerOffOptions[value]!;
                      });
                    },
                    options: autoPowerOffOptions.keys.toList(),
                    selectedValue: autoPowerOffOptions.entries
                        .firstWhere((entry) => entry.value == autoPowerOff)
                        .key,
                    label: 'Automatic shut-down',
                  ),
                ),
                ListTile(
                  title: DropDown(
                    onChanged: (value) {
                      int id = int.parse(value!.trim().split('Channel ')[1]);
                      setState(() {
                        autoShareLocationChannel = id;
                      });
                    },
                    options: channelOptions,
                    selectedValue: 'Channel $autoShareLocationChannel',
                    label: 'Auto share location channel (APRS channel)',
                  ),
                ),
                ListTile(
                  title: DropDown(
                    onChanged: (value) {
                      setState(() {
                        wiredMicrophoneSpeaker = hmSpeakerOptions[value]!;
                      });
                    },
                    options: hmSpeakerOptions.keys.toList(),
                    selectedValue: hmSpeakerOptions.entries
                        .firstWhere(
                          (entry) => entry.value == wiredMicrophoneSpeaker,
                        )
                        .key,
                    label: 'Wired microphone speaker',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (editingEnabled)
              Button.primary(
                label: "Save setting",
                onPressed: _updateRadioSetting,
              ),

            const SizedBox(height: 20),
            if (!editingEnabled)
              Button.primary(
                label: 'Use default setting',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PasswordScreen(
                        actionDescription: 'Validate to use default settings',
                        onValidate: () async {
                          await SettingRepository.setDefault();
                          close(
                            content: 'Radio configured with default settings',
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
