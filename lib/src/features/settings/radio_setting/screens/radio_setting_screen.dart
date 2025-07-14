import 'package:aprs/src/features/protect_app/screens/password_screen.dart';
import 'package:aprs/src/features/settings/repository/setting.repository.dart';
import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:aprs/src/widgets/buttons.dart';
import 'package:aprs/src/widgets/dropdown.dart';
import 'package:aprs/src/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:radio/radio.dart';

class RadioSettingScreen extends StatefulWidget {
  const RadioSettingScreen({super.key});

  @override
  State<RadioSettingScreen> createState() => _RadioSettingScreenState();
}

class _RadioSettingScreenState extends State<RadioSettingScreen> {
  late RadioSetting currentSetting;
  final Map<String, int> _doubleChanOptions = {"OFF": 0, "A": 1, "B": 2};

  bool scan = false;
  bool powerSavingMode = false;
  int squelchLevel = 1;
  int doubleChannel = 0;
  int sliderPreview = 1;
  bool audioRelay = false;

  bool editingEnabled = false;

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
    // RadioExtract.radio.radioSetting = newSetting;
    close();
  }

  void populateSettings() {
    currentSetting = RadioExtract.radio.radioSetting;
    setState(() {
      scan = currentSetting.scan;
      powerSavingMode = currentSetting.powerSavingMode;
      squelchLevel = currentSetting.squelchLevel;
      audioRelay = currentSetting.autoRelayEn;
      doubleChannel = currentSetting.doubleChannel;
      sliderPreview = squelchLevel;
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
      appBar: AppBar(title: Text("Radio Settings")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
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
                          doubleChannel = _doubleChanOptions[val]!;
                        });
                      }
                    : null,
                options: _doubleChanOptions.keys.toList(),
                selectedValue: _doubleChanOptions.entries
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
            const SizedBox(height: 20),
            editingEnabled
                ? Button.primary(
                    label: "Save setting",
                    onPressed: _updateRadioSetting,
                  )
                : Button.outlined(
                    label: "Enable editing",
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
