import 'package:aprs/src/features/aprs_log/screens/aprs_log_screen.dart';
import 'package:aprs/src/features/channel/screens/channel_main_screen.dart';
import 'package:aprs/src/features/map/screens/map_screen.dart';
import 'package:aprs/src/features/settings/setting_layout.dart';
import 'package:aprs/src/helpers/event_handler.dart';
import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:aprs/src/features/channel/screens/channel_screen.dart';
import 'package:flutter/material.dart';

import 'message/repository/message.repository.dart';
import 'message/screens/chat_list_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int unreadChatCount = 0;

  void addEventHandler() async {
    await RadioExtract.radio.addEventHandler(radioEventsHandler);
  }

  void getChatCount() async {
    int count = await MessageRepository.getUnreadChatCount();
    setState(() {
      unreadChatCount = count;
    });
  }

  dynamic listener;

  void addChatListener() {
    getChatCount();
    listener = (dynamic value) => getChatCount();

    MessageRepository.appEvent.addEventListener(
      MyEvents.newChatEvent,
      listener,
    );
  }

  @override
  void initState() {
    if (mounted) {
      addEventHandler();
      addChatListener();
    }
    super.initState();
  }

  @override
  void dispose() {
    MessageRepository.appEvent.removeEventListener(
      MyEvents.newChatEvent,
      listener: listener,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatListScreen()),
              );
            },
            icon: Badge(
              label: Text(
                unreadChatCount > 0 ? unreadChatCount.toString() : '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              backgroundColor: unreadChatCount > 0
                  ? Colors.redAccent
                  : Colors.transparent,
              child: Icon(Icons.message),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChannelMainScreen()),
              );
            },
            icon: Icon(Icons.radio),
            tooltip: 'Channels',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AprsLogScreen()),
              );
            },
            icon: Icon(Icons.list_alt),
            tooltip: 'Aprs logs',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingLayout()),
              );
            },
            icon: Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      drawer: ChannelScreen(),
      body: MapScreen(),
    );
  }
}
