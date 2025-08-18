import 'package:flutter/material.dart';
import 'package:drr_radio_tracker/src/features/splash_screen.dart';
import 'package:drr_radio_tracker/src/helpers/theme.dart';
import 'package:drr_radio_tracker/src/helpers/utils.dart';
import 'package:window_manager/window_manager.dart';

const WindowOptions windowOptions = WindowOptions(
  size: Size(800, 700),
  maximumSize: Size(800, 700),
  minimumSize: Size(800, 700),
  center: true,
  title: 'DRR Radio Tracker',
  // titleBarStyle: TitleBarStyle.hidden,
  fullScreen: false,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (isLargeScreen) {
    await windowManager.ensureInitialized();

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setMaximizable(false);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // await copyMBTilesToLocal();
  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DRR Radio Tracker',
      theme: greenTheme,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
