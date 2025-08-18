import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:drr_radio_tracker/src/features/message/repository/message.repository.dart';
import 'package:drr_radio_tracker/src/helpers/theme.dart' show inputDecoration;
import 'package:drr_radio_tracker/src/widgets/dropdown.dart' show DropDown;

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final TextEditingController _ssidController = TextEditingController(
    text: "0",
  );
  final TextEditingController _callsignController = TextEditingController();
  String errorText = "";

  final _formKey = GlobalKey<FormState>();

  Future<void> addChat(String callsign) async {
    await MessageRepository.addChat(callsign, "", sent: true);
  }

  @override
  void dispose() {
    _callsignController.dispose();
    _ssidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new chat")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              TextFormField(
                controller: _callsignController,
                autovalidateMode: AutovalidateMode.onUnfocus,
                keyboardType: TextInputType.number,
                decoration: inputDecoration(
                  'Callsign',
                ).copyWith(hintText: "ALL for broadcast"),
                validator: (value) {
                  String? val = value?.trim();
                  if (val == null || val.isEmpty) {
                    return "Callsign is required";
                  }
                  if (val.length < 3 || val.length > 7) {
                    return "Callsign should have 3 to 7 characters";
                  }
                  return null;
                },
                onSaved: (x) {
                  String? val = _callsignController.text.trim();
                  if (val.isNotEmpty) {
                    if (val == "ALL") {
                      if (kDebugMode) {
                        print("CALLSIGN IS ALL");
                      }
                      setState(() {
                        _ssidController.text = "0";
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 30),
              DropDown(
                label: "SSID (Ignored if callsign is ALL)",
                onChanged: (value) {
                  _ssidController.text = value!;
                },
                options: List.generate(15, (i) => (i).toString()),
                selectedValue: _ssidController.text,
                validator: (dynamic val) {
                  if (kDebugMode) {
                    print("Selected ssid: $val");
                  }
                  if (_callsignController.text.trim().toUpperCase() != "ALL") {
                    if (val == "0") {
                      return "SSID value should range from 1 to 15";
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  String callsign = "";
                  callsign = _callsignController.text.trim();

                  if (callsign != "ALL") {
                    callsign = "$callsign-${_ssidController.text.trim()}";
                  }

                  await addChat(callsign);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
