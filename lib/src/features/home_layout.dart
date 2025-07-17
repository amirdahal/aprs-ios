import 'dart:async';

import 'package:aprs/src/features/aprs_log/screens/aprs_log_screen.dart';
import 'package:aprs/src/features/bluetooth/screens/bluetooth_screen.dart';
import 'package:aprs/src/features/channel/screens/channel_screen.dart';
import 'package:aprs/src/features/map/screens/map_screen.dart';
import 'package:aprs/src/features/settings/app_setting/repository/app_setting.repository.dart';
import 'package:aprs/src/features/settings/drr_setting/repository/drr.repository.dart';
import 'package:aprs/src/features/settings/setting_layout.dart';
import 'package:aprs/src/helpers/app.events.dart';
import 'package:aprs/src/helpers/event_handler.dart';
import 'package:aprs/src/helpers/my_position.util.dart';
import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:aprs/src/widgets/battery_level.widget.dart';
import 'package:aprs/src/widgets/buttons.dart';
import 'package:aprs/src/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'message/repository/message.repository.dart';
import 'message/screens/chat_list_screen.dart';

class HomeLayout extends StatefulWidget {
  final String connectedDeviceName;

  const HomeLayout({super.key, required this.connectedDeviceName});

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
    if (enablePositionSharing) DrrRepository.startDrr();
  }

  String get connectedDeviceName => widget.connectedDeviceName;
  late StreamSubscription _chatSubscription;
  late StreamSubscription _connectionSubscription;
  late Timer _batteryReaderTimer;

  void addChatListener() {
    getChatCount();
    _chatSubscription = eventBus.on<NewChatEvent>().listen((event) {
      getChatCount();
    });
  }

  void resetApp() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BluetoothScreen()),
    );
  }

  void addConnectionListener() {
    _connectionSubscription = eventBus.on<DeviceDisconnectedEvent>().listen((
      event,
    ) {
      debugPrint("Event received to disconnect");
      resetApp();
    });
  }

  Future<void> _getBatteryLevel() async {
    _batteryLevel = await RadioExtract.radio.batteryLevelAsPercentage();
    setState(() {});
  }

  void updateBatteryLevel() {
    Future.delayed(const Duration(seconds: 10), _getBatteryLevel);
    _batteryReaderTimer = Timer.periodic(
      const Duration(seconds: 45),
      (timer) => _getBatteryLevel,
    );
  }

  @override
  void initState() {
    if (mounted) {
      seedPassword();
      drrInit();
      addEventHandler();
      addChatListener();
      addConnectionListener();
      updateBatteryLevel();
    }
    super.initState();
  }

  @override
  void dispose() {
    _batteryReaderTimer.cancel();
    _chatSubscription.cancel();
    _connectionSubscription.cancel();
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(connectedDeviceName),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu),
          tooltip: 'Channels',
        ),
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
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    icon: Icon(Icons.power_settings_new_sharp),
                    title: Text("Disconnect Device?"),
                    actions: [
                      Button.outlined(
                        label: 'Cancel',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Button.primary(
                        label: 'Disconnect',
                        onPressed: () async {
                          bool success = await RadioExtract.radio.dispose();
                          if (!success) {
                            showToast(
                              context: context,
                              title: 'Failed to disconnect',
                              description: '',
                              type: ToastificationType.error,
                            );
                          }
                          // Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.power_settings_new_outlined),
            tooltip: 'Disconnect',
          ),
        ],
      ),
      drawer: ChannelScreen(),
      body: MapScreen(),
    );
  }
}
