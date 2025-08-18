import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radio/radio.dart';
import 'package:drr_radio_tracker/src/features/channel/repository/channel_repository.dart';
import 'package:drr_radio_tracker/src/features/channel/utils/constants.dart';
import 'package:drr_radio_tracker/src/features/channel/utils/helpers.dart'
    show getToneLabel, toneStringToValue, frequencyValidator;
import 'package:drr_radio_tracker/src/features/protect_app/screens/password_screen.dart';
import 'package:drr_radio_tracker/src/helpers/theme.dart' show inputDecoration;
import 'package:drr_radio_tracker/src/widgets/checkbox.dart' show CustomCheckbox;
import 'package:drr_radio_tracker/src/widgets/dropdown.dart' show DropDown;
import 'package:drr_radio_tracker/src/widgets/toast.dart' show showToast;
import 'package:toastification/toastification.dart';

enum STATE { success, error }

class ChannelDetailScreen extends StatefulWidget {
  final RfChannel channel;
  const ChannelDetailScreen({super.key, required this.channel});

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _rxController = TextEditingController(text: "");
  final TextEditingController _txController = TextEditingController(text: "");
  final TextEditingController _modeController = TextEditingController(text: "");
  final TextEditingController _bandwidthController = TextEditingController(
    text: "WIDE",
  );
  final TextEditingController _powerController = TextEditingController(
    text: "LOW",
  );
  final TextEditingController _rxCtcssController = TextEditingController(
    text: "None",
  );
  final TextEditingController _txCtcssController = TextEditingController(
    text: "None",
  );

  bool disableTransmit = false;
  bool mute = false;
  bool scan = false;
  bool talkAround = false;
  bool deEmplasis = false;
  bool sign = false;
  bool fixedFrequency = false;
  bool fixedTxPower = false;
  bool fixedBandwidth = false;
  late RfChannel channel;

  final List<String> modOptions = ["AM", "FM"];

  bool editingEnabled = false;

  @override
  void initState() {
    channel = widget.channel;
    String pw = "LOW";
    if (channel.txAtMedPower) {
      pw = "MEDIUM";
    } else if (channel.txAtMaxPower) {
      pw = "HIGH";
    }

    setState(() {
      _nameController.text = channel.nameStr;
      _rxController.text = channel.rxFreq.toString();
      _txController.text = channel.txFreq.toString();
      _modeController.text = channel.rxMod.name.toUpperCase();
      _bandwidthController.text = channel.bandwidth.name.toUpperCase();
      _rxCtcssController.text = getToneLabel(channel.rxSubAudio);
      _txCtcssController.text = getToneLabel(channel.txSubAudio);
      _powerController.text = pw;
      disableTransmit = channel.txDisable;
      mute = channel.mute;
      scan = channel.scan;
      talkAround = channel.talkAround;
      deEmplasis = channel.preDeEmphBypass;
      sign = channel.sign;
      fixedFrequency = channel.fixedFreq;
      fixedTxPower = channel.fixedTxPower;
      fixedBandwidth = channel.fixedBandwidth;
      super.initState();
    });
  }

  @override
  void dispose() {
    _powerController.dispose();
    _rxCtcssController.dispose();
    _txCtcssController.dispose();
    _rxController.dispose();
    _txController.dispose();
    _nameController.dispose();
    _modeController.dispose();
    _bandwidthController.dispose();
    super.dispose();
  }

  void close() {
    Navigator.of(context).pop();
  }

  void toast(STATE state) {
    if (state == STATE.success) {
      showToast(
        context: context,
        title: "RF Channel",
        description: "Channel updated successfully",
      );
    } else {
      showToast(
        context: context,
        type: ToastificationType.error,
        title: "RF Channel",
        description: "Channel update failed",
      );
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      String power = _powerController.text.trim().toUpperCase();

      ModulationType mod = _modeController.text.trim() == "AM"
          ? ModulationType.am
          : ModulationType.fm;

      RfChannel updateChan = RfChannel(
        channelId: channel.channelId,
        txMod: mod,
        txFreq: double.parse(_txController.text.trim()),
        rxMod: mod,
        rxFreq: double.parse(_rxController.text.trim()),
        txSubAudio: toneStringToValue(_txCtcssController.text.trim()),
        rxSubAudio: toneStringToValue(_rxCtcssController.text.trim()),
        scan: scan,
        txAtMaxPower: power == "HIGH",
        talkAround: talkAround,
        bandwidth: _bandwidthController.text.trim() == "NARROW"
            ? BandwidthType.narrow
            : BandwidthType.wide,
        preDeEmphBypass: deEmplasis,
        sign: sign,
        txAtMedPower: power == "MEDIUM",
        txDisable: disableTransmit,
        fixedFreq: fixedFrequency,
        fixedBandwidth: fixedBandwidth,
        fixedTxPower: fixedTxPower,
        mute: mute,
        nameStr: _nameController.text.trim(),
      );

      if (kDebugMode) {
        print(updateChan.toMap());
      }
      try {
        ReplyStatus status = await ChannelRepository.updateChannel(updateChan);
        if (status == ReplyStatus.success) {
          toast(STATE.success);
          close();
        } else {
          toast(STATE.error);
        }
      } catch (e) {
        toast(STATE.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("[${widget.channel.channelId}] ${widget.channel.nameStr}"),
        actions: [
          if (!editingEnabled)
            IconButton(
              onPressed: () async {
                bool isValidated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PasswordScreen(
                      onValidate: null,
                      actionDescription:
                          'Validate to edit channel configuration',
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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextFormField(
                  enabled: editingEnabled,
                  controller: _nameController,
                  maxLength: 10,
                  decoration: inputDecoration('Name'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  enabled: editingEnabled,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  controller: _rxController,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration('Rx Frequency'),
                  validator: frequencyValidator,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  enabled: editingEnabled,
                  controller: _txController,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration('Tx Frequency'),
                  validator: frequencyValidator,
                ),
                const SizedBox(height: 15),
                DropDown(
                  label: "Mode",
                  onChanged: editingEnabled
                      ? (value) {
                          setState(() {
                            _modeController.text = value!;
                          });
                        }
                      : null,
                  options: modOptions,
                  selectedValue: "FM",
                ),
                const SizedBox(height: 15),
                DropDown(
                  label: "Transmit CTCSS/DCS",
                  onChanged: editingEnabled
                      ? (value) {
                          _txCtcssController.text = value!;
                        }
                      : null,
                  options: tones,
                  selectedValue: _txCtcssController.text,
                ),
                const SizedBox(height: 15),
                DropDown(
                  label: "Receive CTCSS/DCS",
                  onChanged: editingEnabled
                      ? (value) {
                          _rxCtcssController.text = value!;
                        }
                      : null,
                  options: tones,
                  selectedValue: _rxCtcssController.text,
                ),
                const SizedBox(height: 15),
                DropDown(
                  label: "Bandwidth",
                  onChanged: editingEnabled
                      ? (value) {
                          _bandwidthController.text = value!;
                        }
                      : null,
                  options: bandwidth,
                  selectedValue: _bandwidthController.text,
                ),
                const SizedBox(height: 15),
                DropDown(
                  label: "Power",
                  onChanged: editingEnabled
                      ? (value) {
                          _powerController.text = value!;
                        }
                      : null,
                  options: power,
                  selectedValue: _powerController.text,
                ),
                const SizedBox(height: 15),
                CustomCheckbox(
                  label: "Disable transmit",
                  checked: disableTransmit,
                  onChanged: editingEnabled
                      ? (bool? value) {
                          setState(() {
                            disableTransmit = value!;
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 15),
                CustomCheckbox(
                  label: "Mute",
                  checked: mute,
                  onChanged: editingEnabled
                      ? (bool? value) {
                          setState(() {
                            mute = value!;
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 15),
                CustomCheckbox(
                  label: "Scan",
                  checked: scan,
                  onChanged: editingEnabled
                      ? (bool? value) {
                          setState(() {
                            scan = value!;
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 15),
                CustomCheckbox(
                  label: "Talk around",
                  checked: talkAround,
                  onChanged: editingEnabled
                      ? (bool? value) {
                          setState(() {
                            talkAround = value!;
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 15),
                CustomCheckbox(
                  label: "De-emphasis",
                  checked: deEmplasis,
                  onChanged: editingEnabled
                      ? (bool? value) {
                          setState(() {
                            deEmplasis = value!;
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 15),
                CustomCheckbox(
                  label: "Sign",
                  checked: sign,
                  onChanged: editingEnabled
                      ? (bool? value) {
                          setState(() {
                            sign = value!;
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 15),
                CustomCheckbox(
                  label: "Fixed frequency",
                  checked: fixedFrequency,
                  onChanged: editingEnabled
                      ? (bool? value) {
                          setState(() {
                            fixedFrequency = value!;
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 15),
                CustomCheckbox(
                  label: "Fixed Tx power",
                  checked: fixedTxPower,
                  onChanged: editingEnabled
                      ? (bool? value) {
                          setState(() {
                            fixedTxPower = value!;
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 15),
                CustomCheckbox(
                  label: "Fixed bandwidth",
                  checked: fixedBandwidth,
                  onChanged: editingEnabled
                      ? (bool? value) {
                          setState(() {
                            fixedBandwidth = value!;
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 15),
                if (editingEnabled)
                  ElevatedButton(
                    onPressed: _submit,
                    style: const ButtonStyle(enableFeedback: true),
                    child: const Text(
                      "Save channel",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
