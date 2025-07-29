import 'package:flutter/material.dart';
import 'package:smart_rf/src/features/splash_screen.dart';
import 'package:smart_rf/src/helpers/theme.dart';
import 'package:smart_rf/src/helpers/utils.dart';
import 'package:window_manager/window_manager.dart';

const WindowOptions windowOptions = WindowOptions(
  size: Size(800, 700),
  maximumSize: Size(800, 700),
  minimumSize: Size(800, 700),
  center: true,
  title: 'Smart RF',
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
      title: 'Smart RF',
      theme: greenTheme,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
