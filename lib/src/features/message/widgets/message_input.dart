import 'package:aprs/src/features/message/repository/message.repository.dart';
import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:aprs/src/helpers/theme.dart' show inputDecoration;
import 'package:aprs/src/model/model.dart' show ChatStore;
import 'package:flutter/material.dart';
import 'package:radio/radio.dart';

class MessageInput extends StatefulWidget {
  final ChatStore currentChat;
  const MessageInput({super.key, required this.currentChat});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  static int messageId = 0;
  static bool sendBtnEnabled = true;
  final TextEditingController messageController = TextEditingController();

  void addMessage() async {
    AprsSetting aprsSetting = RadioExtract.radio.aprsSetting;
    var myCallsign = '${aprsSetting.aprsCallsign}-${aprsSetting.aprsSsid}';

    // Map<String, dynamic> newMessage = {
    //   "time": DateTime.now(),
    //   "from": myCallsign,
    //   "to": widget.currentChat.callsign,
    //   "messageText": messageController.text.trim(),
    //   "messageId": messageId.toString(),
    //   "sent": true,
    // };

    MessagePacket messagePacket = MessagePacket(
      timestamp: DateTime.timestamp(),
      source: myCallsign,
      destination: 'APN000',
      digipeaters: [],
      recipient: widget.currentChat.callsign!,
      messageText: messageController.text.trim(),
    );

    MessageRepository.addMessage(messagePacket);
  }

  Future<void> sendMessage() async {
    setState(() {
      sendBtnEnabled = false;
    });
    String message = messageController.text.trim();
    if (message.isNotEmpty) {
      await RadioExtract.radio.sendMessage(
        recipient: widget.currentChat.callsign!,
        message: message,
        messageId: messageId,
      );

      addMessage();

      messageId++;

      setState(() {
        messageController.clear();
        sendBtnEnabled = true;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: TextFormField(
                  enabled: sendBtnEnabled,
                  controller: messageController,
                  maxLength: 65,
                  decoration: inputDecoration("Type your message"),
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      sendMessage();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: sendBtnEnabled ? sendMessage : null,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
