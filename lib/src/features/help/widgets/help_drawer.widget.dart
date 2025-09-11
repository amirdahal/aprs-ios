import 'package:flutter/material.dart';

import '../constants/help_menu_items.dart';

class HelpDrawer extends StatelessWidget {
  final void Function(Widget) onHelpSelect;
  const HelpDrawer({super.key, required this.onHelpSelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsetsGeometry.all(10),
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(color: Colors.green),
            child: Text(
              'Help Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
              // textAlign: TextAlign.center,
            ),
          ),
          for (var item in helpMenuItems)
            ListTile(
              leading: Icon(item.iconData),
              title: Text(item.label),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                onHelpSelect(item.helpScreen);
              },
            ),
        ],
      ),
    );
  }
}
