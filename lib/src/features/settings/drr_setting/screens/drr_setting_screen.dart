import 'package:aprs/src/features/settings/drr_setting/repository/drr.repository.dart';
import 'package:aprs/src/helpers/theme.dart';
import 'package:aprs/src/model/model.dart';
import 'package:aprs/src/widgets/buttons.dart';
import 'package:aprs/src/widgets/dropdown.dart' show DropDown;
import 'package:aprs/src/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class DrrSettingScreen extends StatefulWidget {
  const DrrSettingScreen({super.key});

  @override
  State<DrrSettingScreen> createState() => _DrrSettingScreenState();
}

class _DrrSettingScreenState extends State<DrrSettingScreen> {
  DrrStore? _drrStore;
  final _formKey = GlobalKey<FormState>();

  bool _drrEnabled = false;
  final TextEditingController _drrUuidController = TextEditingController(
    text: '',
  );
  final TextEditingController _sendIntervalController = TextEditingController(
    text: '30',
  );

  final TextEditingController _commentController = TextEditingController(
    text: '',
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

  Future<bool> testConnection() async {
    return true;
  }

  void showMessage(String content, bool error) {
    showSnackBar(context: context, content: content, error: error);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_drrEnabled) {
      bool isValid = await testConnection();
      if (!isValid) {
        showMessage('Could not validate configuration', true);
      } else {
        if (_drrStore != null) {
          _drrStore?.interval = int.parse(_sendIntervalController.text.trim());
          _drrStore?.uuid = _drrUuidController.text.trim();
          _drrStore?.comment = _commentController.text.trim();
          _drrStore?.sendMyPosition = _drrEnabled;
        } else {
          _drrStore = DrrStore(
            uuid: _drrUuidController.text.trim(),
            interval: int.parse(_sendIntervalController.text.trim()),
            comment: _commentController.text.trim(),
            sendMyPosition: _drrEnabled,
          );
        }
        DrrRepository.setDrrConfig(_drrStore!);
        showMessage('Drr configuration saved', false);
      }
    }
  }

  void fetchDrr() async {
    var drr = await DrrRepository.getDrrConfig();
    print(drr?.toMap());
    if (drr != null) {
      _drrStore = drr;
      setState(() {
        _drrEnabled = drr.sendMyPosition!;
        _drrUuidController.text = drr.uuid!;
        _commentController.text = drr.comment!;
        _sendIntervalController.text = drr.interval.toString();
      });
    }
  }

  @override
  void initState() {
    fetchDrr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drr Settings")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                title: Text("Send position to DRR.center"),
                trailing: Switch(
                  value: _drrEnabled,
                  onChanged: (value) {
                    setState(() {
                      _drrEnabled = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _drrUuidController,
                enabled: _drrEnabled,
                decoration: inputDecoration('Registered UUID'),
                validator: (value) {
                  if (!_drrEnabled) {
                    return null;
                  }

                  if (value == null || value.isEmpty) {
                    return 'DRR registered UUID is required';
                  }

                  if (!isUUID(value)) {
                    return 'Enter a valid UUID';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _commentController,
                enabled: _drrEnabled,
                decoration: inputDecoration('Comment'),
                maxLength: 50,
                validator: (value) {
                  if (!_drrEnabled) {
                    return null;
                  }

                  if (value == null || value.isEmpty) {
                    return 'Comment is required';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropDown(
                onChanged: _drrEnabled
                    ? (val) {
                        _sendIntervalController.text = val!;
                      }
                    : null,
                options: _locationShareIntervalOptions,
                selectedValue: _sendIntervalController.text,
                label: 'Location share interval (minutes)',
              ),
              const SizedBox(height: 50),

              Button.primary(label: 'Save setting', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
