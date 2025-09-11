import 'package:drr_radio_tracker/src/features/help/constants/help.mixin.dart';
import 'package:drr_radio_tracker/src/features/help/widgets/builder.widget.dart';
import 'package:flutter/material.dart';

class MessagingHelpScreen extends StatelessWidget with HelpPageMixin {
  const MessagingHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        BuildImage(
          imageName: 'messaging_screen.png',
          caption: "APRS messsaging",
        ),

        // const SizedBox(height: 24),
        BuildSection(
          title: "About this screen",
          content:
              "This screen allows you to send and receive APRS messages.\n"
              "You can send messages to any valid APRS callsign, and view messages sent to your callsign.\n"
              "Messages are sent via the connected radio, so ensure your radio is powered on and connected.\n"
              "You can also view recent messages received from other users.\n",
        ),

        const SizedBox(height: 24),

        BuildSection(
          title: "Create a new chat",
          content:
              "Follow the below instructions to start a new chat: \n\n"
              "** To create a broadcast chat, use `ALL` as the callsign and select `0` as ssid **",
        ),

        BuildSteps(
          steps: [
            "Tap the '+' button to start a new chat.",
            "Enter the recipient's APRS callsign (e.g., CALL), and select the ssid from the ssid options dropdown.",
            "Click on `Add` to save the new chat.",
          ],
        ),

        const SizedBox(height: 24),

        BuildSection(
          title: "Sending a message",
          content:
              "Follow the below instructions to send a message:\n"
              "** Note : You can only send messages to chats that you have created. Each message is limited to 65 characters **",
        ),

        BuildSteps(
          steps: [
            "Select the chat you want to send a message to from the list of chats.",
            "Type your message in the text input field at the bottom of the screen.",
            "Tap the send button (paper plane icon) to send your message.",
          ],
        ),

        const SizedBox(height: 24),

        BuildSection(
          title: "Features in chat and messaging",
          content:
              "View messages: All messages sent and received in the chat are displayed in the chat window. New messages will appear at the bottom of the list.\n\n"
              "Scroll: You can scroll through the chat history to view previous messages.\n\n"
              "Notifications: An indicator for new message will be displayed in the main screen's message icon when you are not in the chat screen.",
        ),
      ],
    );
  }

  @override
  String get label => "APRS messaging";
}
