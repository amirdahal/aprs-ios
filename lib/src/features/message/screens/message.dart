import 'dart:async';

import 'package:flutter/material.dart';
import 'package:drr_radio_tracker/src/features/message/repository/message.repository.dart';
import 'package:drr_radio_tracker/src/features/message/widgets/message_input.dart';
import 'package:drr_radio_tracker/src/features/message/widgets/message_tile.dart';
import 'package:drr_radio_tracker/src/helpers/app.events.dart'
    show eventBus, NewMessageEvent;
import 'package:drr_radio_tracker/src/model/model.dart' show ChatStore, MessageStore;

class MessageScreen extends StatefulWidget {
  final ChatStore currentChat;

  const MessageScreen({super.key, required this.currentChat});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<MessageStore> _messages = [];
  ScrollController scrollController = ScrollController();

  // CustomEvents events = CustomEvents.instance;

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

  late StreamSubscription messageSubscription;

  void addListener() {
    fetchMessages();
    messageSubscription = eventBus.on<NewMessageEvent>().listen((event) {
      if (event.callsign == widget.currentChat.callsign) {
        fetchMessages();
      }
    });
    // events.addEventListener(MyEvents.newMessageEvent, (callsign) async {
    //   if (callsign == widget.currentChat.callsign) {
    //     fetchMessages();
    //   }
    // });
  }

  @override
  void initState() {
    addListener();
    if (mounted) {}
    super.initState();
  }

  @override
  void dispose() {
    messageSubscription.cancel();
    // events.removeEventListener(MyEvents.newMessageEvent);
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
