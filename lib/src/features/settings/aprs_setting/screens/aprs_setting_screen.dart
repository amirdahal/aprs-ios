import 'package:aprs/src/features/protect_app/screens/password_screen.dart'
    show PasswordScreen;
import 'package:aprs/src/helpers/radio_extract.dart' show RadioExtract;
import 'package:aprs/src/helpers/theme.dart';
import 'package:aprs/src/widgets/buttons.dart' show Button;
import 'package:aprs/src/widgets/dropdown.dart';
import 'package:aprs/src/widgets/toast.dart' show showSnackBar;
import 'package:flutter/material.dart';
import 'package:radio/radio.dart';

class AprsSettingScreen extends StatefulWidget {
  const AprsSettingScreen({super.key});

  @override
  State<AprsSettingScreen> createState() => _AprsSettingScreenState();
}

class _AprsSettingScreenState extends State<AprsSettingScreen> {
  final List<String> _ssidOptions = List.generate(
    15,
    (i) => (i + 1).toString(),
  );

  final List<String> _locationShareIntervalOptions = [
    "1",
    "5",
    "10",
    "15",
    "30",
    "60",
    "90",
    "120",
  ];

  final TextEditingController _callsignController = TextEditingController();

  final TextEditingController _ssidController = TextEditingController(
    text: "1",
  );

  final TextEditingController _messageController = TextEditingController();

  final TextEditingController _intervalController = TextEditingController(
    text: "30",
  );

  bool editingEnabled = false;

  late AprsSetting currentSetting;

  final _formKey = GlobalKey<FormState>();

  void populateSettings() {
    currentSetting = RadioExtract.radio.aprsSetting;
    setState(() {
      _callsignController.text = currentSetting.aprsCallsign;
      _ssidController.text = currentSetting.aprsSsid.toString();
      _messageController.text = currentSetting.beaconMessage;
      int interval = (currentSetting.locationShareInterval / 60).toInt();
      if (_locationShareIntervalOptions.contains(interval.toString())) {
        _intervalController.text = interval.toString();
      } else {
        _intervalController.text = "30";
      }
    });
  }

  Future<void> _updateAprsSetting() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    int ssid = int.parse(_ssidController.text.trim());
    int interval = int.parse(_intervalController.text.trim()) * 60;
    AprsSetting newSetting = RadioExtract.radio.aprsSetting.copyWith();
    newSetting.aprsCallsign = _callsignController.text.trim();
    newSetting.aprsSsid = ssid;
    newSetting.beaconMessage = _messageController.text.trim();
    newSetting.locationShareInterval = interval;
    await RadioExtract.radio.setAprsSettings(newSetting);
    setState(() {
      editingEnabled = false;
    });
    close();
  }

  void close() {
    showSnackBar(
      context: context,
      content: 'Aprs setting updated.',
      actionLabel: 'Close',
      action: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    populateSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aprs Settings")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                enabled: editingEnabled,
                controller: _callsignController,
                decoration: inputDecoration('APRS callsign'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "APRS callsign cannot be empty";
                  }

                  if (value.length < 3 || value.length > 7) {
                    return "APRS callsign should contain between 3 to 7 characters";
                  }

                  _callsignController.text = value.toUpperCase();

                  return null;
                },
              ),

              const SizedBox(height: 20),
              DropDown(
                onChanged: editingEnabled
                    ? (value) {
                        _ssidController.text = value!;
                      }
                    : null,
                options: _ssidOptions,
                selectedValue: _ssidController.text,
                label: 'Aprs ssid',
              ),
              const SizedBox(height: 20),

              TextFormField(
                enabled: editingEnabled,
                controller: _messageController,
                decoration: inputDecoration('Aprs message'),
              ),

              const SizedBox(height: 20),
              DropDown(
                onChanged: editingEnabled
                    ? (val) {
                        _intervalController.text = val!;
                      }
                    : null,
                options: _locationShareIntervalOptions,
                selectedValue: _intervalController.text,
                label: 'Location share interval (minutes)',
              ),
              const SizedBox(height: 40),
              editingEnabled
                  ? Button.primary(
                      label: "Save setting",
                      onPressed: _updateAprsSetting,
                    )
                  : Button.outlined(
                      label: "Enable editing",
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
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
