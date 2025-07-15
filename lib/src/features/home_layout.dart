import 'dart:async';

import 'package:aprs/src/features/aprs_log/screens/aprs_log_screen.dart';
import 'package:aprs/src/features/map/screens/map_screen.dart';
import 'package:aprs/src/features/settings/app_setting/repository/app_setting.repository.dart';
import 'package:aprs/src/features/settings/drr_setting/repository/drr.repository.dart';
import 'package:aprs/src/features/settings/setting_layout.dart';
import 'package:aprs/src/helpers/event_handler.dart';
import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:aprs/src/features/channel/screens/channel_screen.dart';
import 'package:aprs/src/widgets/battery_level.widget.dart';
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
  int? _batteryLevel;

  void addEventHandler() async {
    await RadioExtract.radio.addEventHandler(radioEventsHandler);
  }

  void getChatCount() async {
    int count = await MessageRepository.getUnreadChatCount();
    setState(() {
      unreadChatCount = count;
    });
  }

  void seedPassword() async {
    await AppSettingRepository.seedPassword();
  }

  void drrInit() async {
    await DrrRepository.seedDrr();
    DrrRepository.startDrr();
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

  Future<void> _getBatteryLevel() async {
    _batteryLevel = await RadioExtract.radio.batteryLevelAsPercentage();
    setState(() {});
  }

  void updateBatteryLevel() {
    Future.delayed(const Duration(seconds: 5), _getBatteryLevel);
    Timer.periodic(const Duration(minutes: 2), (timer) => _getBatteryLevel);
  }

  @override
  void initState() {
    if (mounted) {
      seedPassword();
      drrInit();
      addEventHandler();
      addChatListener();
      updateBatteryLevel();
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
          if (_batteryLevel != null)
            BatteryIndicator(batteryLevel: _batteryLevel!),
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
              child: Icon(Icons.local_post_office_outlined),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AprsLogScreen()),
              );
            },
            icon: Icon(Icons.list_alt_outlined),
            tooltip: 'Aprs logs',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingLayout()),
              );
            },
            icon: Icon(Icons.settings_outlined),
            tooltip: 'Settings',
          ),
        ],
      ),
      drawer: ChannelScreen(),
      body: MapScreen(),
    );
  }
}
