import 'package:aprs/src/helpers/event_handler.dart';
import 'package:flutter/material.dart';

class AprsLogScreen extends StatelessWidget {
  const AprsLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aprs Logs')),
      body: ValueListenableBuilder(
        valueListenable: aprsPositionPackets,
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              var packet = value[index];
              return ListTile(
                title: Row(
                  children: [
                    Text(packet.source),
                    Icon(Icons.arrow_right_alt_outlined, color: Colors.grey),
                    Text(packet.destination),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Text(
                      'Latitude: ',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(packet.latitude.toStringAsFixed(3)),
                    const SizedBox(width: 10),
                    Text(
                      'Longitude: ',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(packet.longitude.toStringAsFixed(3)),
                    const SizedBox(width: 10),
                    Text(
                      'Comment: ',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(packet.comment),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
