import 'package:aprs/src/helpers/utils.dart' show formatTimestamp;
import 'package:aprs/src/model/model.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final MessageStore msg;
  const MessageTile({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    final isSent = msg.sent!;
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Card(
            color: isSent ? Colors.white : Colors.green[300],
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 5.0,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 1.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${msg.sender} -> ${msg.recipient} @${formatTimestamp(msg.timestamp, min: true)}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSent ? Colors.grey : Colors.white,
                      ),
                    ),
                    Text(
                      msg.messageText.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
