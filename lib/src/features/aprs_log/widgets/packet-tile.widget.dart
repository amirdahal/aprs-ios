import 'package:aprs/src/helpers/utils.dart';
import 'package:aprs/src/widgets/aprs_symbol.widget.dart';
import 'package:flutter/material.dart';
import 'package:radio/radio.dart';

class PacketTile extends StatelessWidget {
  final PositionPacket packet;
  final Widget? trailing;
  final bool showTimestamp;
  final bool minTimestamp;
  final bool minTitle;
  const PacketTile({
    super.key,
    required this.packet,
    this.trailing,
    this.showTimestamp = false,
    this.minTimestamp = false,
    this.minTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AprsSymbolIcon(symbolTable: packet.symbolTable, symbol: packet.symbol),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(packet.source),
              if (!minTitle)
                Icon(Icons.arrow_right_alt_outlined, color: Colors.grey),
              if (!minTitle) Text(packet.destination),
            ],
          ),
          if (showTimestamp)
            Text(
              formatTimestamp(packet.timestamp, min: minTimestamp),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
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
