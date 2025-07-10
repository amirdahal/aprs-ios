import 'package:aprs/src/features/message/widgets/message_input.dart';
import 'package:aprs/src/features/message/repository/message.repository.dart';
import 'package:aprs/src/features/message/widgets/message_tile.dart';
import 'package:aprs/src/model/model.dart' show ChatStore, MessageStore;
import 'package:custom_events/custom_events.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final ChatStore currentChat;
  const MessageScreen({super.key, required this.currentChat});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<MessageStore> _messages = [];
  ScrollController scrollController = ScrollController();

  CustomEvents events = CustomEvents.instance;

  Future<void> markAsSeen() async {
    await MessageRepository.markChatAsSeen(widget.currentChat);
  }

  Future<void> fetchMessages() async {
    _messages = await MessageRepository.loadMessages(widget.currentChat);
    setState(() {});
    scrollDown();
    markAsSeen();
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  void initState() {
    if (mounted) {
      fetchMessages();
      events.addEventListener(MyEvents.newMessageEvent, (callsign) async {
        if (callsign == widget.currentChat.callsign) {
          fetchMessages();
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    events.removeEventListener(MyEvents.newMessageEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.currentChat.callsign!)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return MessageTile(msg: _messages[index]);
                },
              ),
            ),
            const Divider(height: 1),
            MessageInput(currentChat: widget.currentChat),
          ],
        ),
      ),
    );
  }
}
