import 'package:flutter/material.dart';

class DrrSettingScreen extends StatefulWidget {
  const DrrSettingScreen({super.key});

  @override
  State<DrrSettingScreen> createState() => _DrrSettingScreenState();
}

class _DrrSettingScreenState extends State<DrrSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drr Settings")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      ),
    );
  }
}
