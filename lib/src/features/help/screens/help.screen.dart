import 'package:drr_radio_tracker/src/features/help/constants/help.mixin.dart';
import 'package:flutter/material.dart';
import '../widgets/help_drawer.widget.dart';
import 'home.screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  Widget currentScreen = HelpHome();
  String title = "About the app";

  void handleHelpSelect(Widget helpScreen) {
    setState(() {
      currentScreen = helpScreen;
      if (helpScreen is HelpPageMixin) {
        title = helpScreen.label;
      } else {
        title = 'Help';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Close help',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      drawer: HelpDrawer(onHelpSelect: handleHelpSelect),
      body: currentScreen,
    );
  }
}
