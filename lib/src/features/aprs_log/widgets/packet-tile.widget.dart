import 'package:flutter/material.dart';
import 'package:radio/radio.dart';

class PacketTile extends StatelessWidget {
  final PositionPacket packet;
  final Widget? trailing;
  const PacketTile({super.key, required this.packet, this.trailing});

  @override
  Widget build(BuildContext context) {
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
          Text('Latitude: ', style: Theme.of(context).textTheme.labelLarge),
          Text(packet.latitude.toStringAsFixed(3)),
          const SizedBox(width: 10),
          Text('Longitude: ', style: Theme.of(context).textTheme.labelLarge),
          Text(packet.longitude.toStringAsFixed(3)),
          const SizedBox(width: 10),
          Text('Comment: ', style: Theme.of(context).textTheme.labelLarge),
          Text(packet.comment),
        ],
      ),
      trailing: trailing,
    );
  }
}
