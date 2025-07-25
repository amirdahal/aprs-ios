import 'package:smart_rf/src/features/protect_app/screens/password_screen.dart'
    show PasswordScreen;
import 'package:smart_rf/src/features/settings/repository/constants.dart';
import 'package:smart_rf/src/helpers/radio_extract.dart' show RadioExtract;
import 'package:smart_rf/src/helpers/theme.dart';
import 'package:smart_rf/src/widgets/buttons.dart' show Button;
import 'package:smart_rf/src/widgets/dropdown.dart';
import 'package:smart_rf/src/widgets/toast.dart' show showSnackBar;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio/radio.dart';

class AprsSettingScreen extends StatefulWidget {
  const AprsSettingScreen({super.key});

  @override
  State<AprsSettingScreen> createState() => _AprsSettingScreenState();
}

class _AprsSettingScreenState extends State<AprsSettingScreen> {
  AprsSetting currentSetting = RadioExtract.radio.aprsSetting;
  DeviceInfo deviceInfo = RadioExtract.radio.deviceInfo;
  final _formKey = GlobalKey<FormState>();

  bool editingEnabled = false;

  TextEditingController callsign = TextEditingController();
  TextEditingController bssUserId = TextEditingController();
  TextEditingController beaconMessage = TextEditingController();
  TextEditingController pttReleaseIdInfo = TextEditingController();

  PacketFormat packetFormat = PacketFormat.aprs;
  int ssid = 1;
  int interval = 600;
  bool shouldShareLocation = true;
  bool allowPositionCheck = true;
  bool sendPowerVoltage = false;
  bool pttReleaseSendLocation = false;
  bool pttReleaseSendIdInfo = false;
  bool pttReleaseSendBssUserId = false;

  void populateSettings() {
    packetFormat = currentSetting.packetFormat;
    interval = currentSetting.locationShareInterval;

    if (!locationShareIntervalOptions.values.toList().contains(interval)) {
      interval = 600;
    }
    shouldShareLocation = currentSetting.shouldShareLocation;
    if (!shouldShareLocation) {
      interval = 0;
    }

    callsign.text = currentSetting.aprsCallsign;
    ssid = currentSetting.aprsSsid;

    beaconMessage.text = currentSetting.beaconMessage;

    allowPositionCheck = currentSetting.allowPositionCheck;
    sendPowerVoltage = currentSetting.sendPwrVoltage;

    bssUserId.text = currentSetting.bssUserId.toString();
    pttReleaseIdInfo.text = currentSetting.pttReleaseIdInfo;

    pttReleaseSendLocation = currentSetting.pttReleaseSendLocation;
    pttReleaseSendBssUserId = currentSetting.pttReleaseSendBssUserId;
    pttReleaseSendIdInfo = currentSetting.pttReleaseSendIdInfo;

    setState(() {});
  }

  Future<void> _updateAprsSetting() async {
    AprsSetting newSetting = AprsSetting(
      maxFwdTimes: 1,
      timeToLive: 3,
      pttReleaseSendLocation: pttReleaseSendLocation,
      pttReleaseSendIdInfo: pttReleaseSendIdInfo,
      pttReleaseSendBssUserId: pttReleaseSendBssUserId,
      shouldShareLocation: shouldShareLocation,
      sendPwrVoltage: sendPowerVoltage,
      packetFormat: packetFormat,
      allowPositionCheck: allowPositionCheck,
      aprsSsid: ssid,
      locationShareInterval: interval,
      bssUserId: int.tryParse(bssUserId.text.trim()) ?? 0,
      pttReleaseIdInfo: pttReleaseIdInfo.text.trim(),
      beaconMessage: beaconMessage.text.trim(),
      aprsSymbol: currentSetting.aprsSymbol,
      aprsCallsign: callsign.text.trim(),
    );

    await RadioExtract.radio.setAprsSettings(newSetting);
    setState(() {
      editingEnabled = false;
    });
    close();
  }

  void close() {
    showSnackBar(context: context, content: 'Aprs setting updated.');
  }

  @override
  void initState() {
    populateSettings();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aprs Settings"),
        actions: [
          if (!editingEnabled)
            IconButton(
              onPressed: () async {
                bool isValidated = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PasswordScreen(
                      actionDescription:
                          'Validate to enable editing the aprs settings',
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
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropDown(
                onChanged: editingEnabled
                    ? (value) {
                        setState(() {
                          packetFormat = packetFormatOptions[value]!;
                        });
                      }
                    : null,
                options: packetFormatOptions.keys.toList(),
                selectedValue: packetFormatOptions.entries
                    .firstWhere((entry) => entry.value == packetFormat)
                    .key,
                label: 'Packet format',
              ),
              if (packetFormat == PacketFormat.aprs)
                TextField(
                  enabled: editingEnabled,
                  controller: callsign,
                  maxLength: 6,
                  decoration: inputDecoration('APRS callsign'),
                ),
              if (packetFormat == PacketFormat.aprs)
                DropDown(
                  onChanged: editingEnabled
                      ? (value) {
                          ssid = int.parse(value!);
                        }
                      : null,
                  options: ssidOptions,
                  selectedValue: ssid.toString(),
                  label: 'Aprs ssid',
                ),

              if (packetFormat == PacketFormat.bss)
                TextField(
                  enabled: editingEnabled,
                  controller: bssUserId,
                  decoration: inputDecoration('BSS user ID'),
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              if (packetFormat == PacketFormat.bss)
                TextField(
                  enabled: editingEnabled,
                  controller: pttReleaseIdInfo,
                  maxLength: 12,
                  decoration: inputDecoration('Identification information'),
                ),

              TextField(
                enabled: editingEnabled,
                controller: beaconMessage,
                decoration: inputDecoration('Message'),
                maxLength: 40,
              ),

              DropDown(
                onChanged: editingEnabled
                    ? (val) {
                        if (val == 'off') {
                          shouldShareLocation = false;
                        } else {
                          shouldShareLocation = true;
                        }
                        interval = locationShareIntervalOptions[val]!;
                      }
                    : null,
                options: locationShareIntervalOptions.keys.toList(),
                selectedValue: locationShareIntervalOptions.entries
                    .firstWhere((entry) => entry.value == interval)
                    .key,
                label: 'Location sharing',
              ),
              ListTile(
                title: const Text("Allow position check"),
                trailing: Switch(
                  value: allowPositionCheck,
                  onChanged: editingEnabled
                      ? (bool value) {
                          setState(() {
                            allowPositionCheck = value;
                          });
                        }
                      : null,
                ),
              ),
              ListTile(
                title: const Text("Send power voltage"),
                trailing: Switch(
                  value: sendPowerVoltage,
                  onChanged: editingEnabled
                      ? (bool value) {
                          setState(() {
                            sendPowerVoltage = value;
                          });
                        }
                      : null,
                ),
              ),
              if (packetFormat == PacketFormat.bss)
                ListTile(
                  title: const Text("Send location on PTT release"),
                  trailing: Switch(
                    value: pttReleaseSendLocation,
                    onChanged: editingEnabled
                        ? (bool value) {
                            setState(() {
                              pttReleaseSendLocation = value;
                            });
                          }
                        : null,
                  ),
                ),
              if (packetFormat == PacketFormat.bss)
                ListTile(
                  title: const Text("Send BSS user ID"),
                  trailing: Switch(
                    value: pttReleaseSendBssUserId,
                    onChanged: editingEnabled
                        ? (bool value) {
                            setState(() {
                              pttReleaseSendBssUserId = value;
                            });
                          }
                        : null,
                  ),
                ),
              if (packetFormat == PacketFormat.bss)
                ListTile(
                  title: const Text("Send ID information"),
                  trailing: Switch(
                    value: pttReleaseSendIdInfo,
                    onChanged: editingEnabled
                        ? (bool value) {
                            setState(() {
                              pttReleaseSendBssUserId = value;
                            });
                          }
                        : null,
                  ),
                ),

              if (editingEnabled)
                Button.primary(
                  label: "Save setting",
                  onPressed: _updateAprsSetting,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
