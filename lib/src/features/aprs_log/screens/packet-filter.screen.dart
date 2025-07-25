import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_rf/src/features/aprs_log/widgets/datetime-picker.widget.dart';
import 'package:smart_rf/src/widgets/buttons.dart';

class PacketFilterScreen extends StatefulWidget {
  const PacketFilterScreen({super.key});

  @override
  State<PacketFilterScreen> createState() => _PacketFilterScreenState();
}

class _PacketFilterScreenState extends State<PacketFilterScreen> {
  DateTime? _start;
  DateTime? _end;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packet filter'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, [null, null]);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  DateTimePicker(
                    label: 'Select start date and time',
                    onDateTimeChanged: (datetime) {
                      _start = datetime;
                      if (kDebugMode) {
                        print(datetime);
                      }
                    },
                  ),
                  DateTimePicker(
                    label: 'Select end date and time',
                    onDateTimeChanged: (datetime) {
                      _end = datetime;
                      if (kDebugMode) {
                        print(datetime);
                      }
                    },
                  ),
                ],
              ),
              Button.primary(
                label: 'Filter',
                onPressed: () {
                  Navigator.pop(context, [_start, _end]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
