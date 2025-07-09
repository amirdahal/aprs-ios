import 'package:aprs/src/features/message/repository/message.repository.dart';
import 'package:aprs/src/features/message/screens/new_chat_screen.dart';
import 'package:aprs/src/helpers/utils.dart' show formatTimestamp;
import 'package:aprs/src/model/model.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatStore> _chats = [];

  void loadChats() async {
    var chats = await MessageRepository.loadChats();
    setState(() {
      _chats = chats;
    });
  }

  @override
  void initState() {
    loadChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewChatScreen()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => MessageScreen(
              //       currentChat: _chats[index],
              //     ),
              //   ),
              // );
            },
            tileColor: _chats[index].seen!
                ? Colors.transparent
                : Colors.primaries.first[50],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _chats[index].callsign!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  formatTimestamp(_chats[index].time, min: true),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            subtitle: Text(_chats[index].lastMessage!),
            leading: Icon(
              Icons.speaker_phone,
              size: 30,
              color: _chats[index].seen! ? Colors.black45 : Colors.green,
            ),
            trailing: _chats[index].seen!
                ? null
                : Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
