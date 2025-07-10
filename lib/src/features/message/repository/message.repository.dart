import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:aprs/src/model/model.dart';
import 'package:flutter/foundation.dart';
import 'package:radio/radio.dart';
import 'package:custom_events/custom_events.dart';

enum MyEvents { newMessageEvent, newChatEvent, drrSettingChangedEvent }

class MessageRepository {
  static CustomEvents appEvent = CustomEvents.instance;

  static Future<void> addChat(
    String callsign,
    String lastMessage, {
    bool sent = false,
  }) async {
    List<ChatStore> chats = await ChatStore()
        .select()
        .callsign
        .equals(callsign)
        .toList();
    if (kDebugMode) {
      print("Pre update: $chats");
    }
    bool seen = sent ? true : false;
    try {
      if (chats.isEmpty) {
        int? res = await ChatStore(
          callsign: callsign,
          lastMessage: lastMessage,
          seen: false,
          time: DateTime.timestamp(),
        ).saveOrThrow();
        if (kDebugMode) {
          print("Save chat: $res");
        }
      } else {
        ChatStore chat = chats.first;
        chat.lastMessage = lastMessage;
        chat.seen = seen;
        chat.time = DateTime.timestamp();
        int? res = await chat.saveOrThrow();
        if (kDebugMode) {
          print("Update chat: $res}");
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error chat save: $e");
      }
    }
    appEvent.dispatchEvent(MyEvents.newChatEvent, value: callsign);
    appEvent.dispatchEvent(MyEvents.newMessageEvent, value: callsign);
  }

  static Future<void> addMessage(MessagePacket message) async {
    AprsSetting aprsSetting = RadioExtract.radio.aprsSetting;
    try {
      final String myCallsign =
          "${aprsSetting.aprsCallsign}-${aprsSetting.aprsSsid}";

      final List<String> allowed = ["ALL", myCallsign];

      MessageStore newMessage = MessageStore(
        sender: message.source,
        recipient: message.recipient,
        messageId: message.messageId ?? 0,
        messageText: message.messageText,
        sent: message.source == myCallsign,
        timestamp: message.timestamp,
      );

      if (allowed.contains(newMessage.sender) ||
          allowed.contains(newMessage.recipient)) {
        int? res = await newMessage.save();

        if (kDebugMode) {
          print("Save message: $res");
        }

        await addChat(
          newMessage.sent! ? newMessage.recipient! : newMessage.sender!,
          newMessage.messageText!,
          sent: newMessage.sent!,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Save message error: $e");
      }
    }
  }

  static Future<List<ChatStore>> loadChats() async {
    return await ChatStore().select().orderByDesc('time').toList();
  }

  static Future<int> getUnreadChatCount() async {
    return await ChatStore().select().seen.equals(false).toCount();
  }

  static Future<List<MessageStore>> loadMessages(ChatStore currentChat) async {
    List<MessageStore> messages = await MessageStore()
        .select()
        .sender
        .equals(currentChat.callsign)
        .or
        .recipient
        .equals(currentChat.callsign)
        .toList();
    return messages;
  }

  static Future<void> markChatAsSeen(ChatStore chat) async {
    ChatStore? ct = await ChatStore().getById(chat.id);
    ct?.seen = true;
    await ct?.save();
    appEvent.dispatchEvent(MyEvents.newChatEvent, value: chat.callsign);
    // await loadChats();
  }
}
