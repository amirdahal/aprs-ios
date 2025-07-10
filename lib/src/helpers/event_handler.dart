import 'package:aprs/src/features/message/repository/message.repository.dart';
import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:flutter/foundation.dart';
import 'package:radio/radio.dart';

enum AppEvents {
  newMessage,
  newBeacon,
  statusChange,
  radioSettingChanged,
  aprsSettingChanged,
}

ValueNotifier<List<PositionPacket>> aprsPositionPackets = ValueNotifier([]);

ValueNotifier<Status> statusChangeNotifier = ValueNotifier(
  RadioExtract.radio.status,
);

ValueNotifier<RadioSetting> settingChangeNotifier = ValueNotifier(
  RadioExtract.radio.radioSetting,
);

void radioEventsHandler(RadioEvents eventType, dynamic data) {
  switch (eventType) {
    case RadioEvents.newBeacon:
      PositionPacket packet = data;
      var packets = aprsPositionPackets.value.toList();
      packets.add(data);
      aprsPositionPackets.value = packets;
      if (kDebugMode) {
        print("New beacon: ${packet.toMap()}");
      }
    case RadioEvents.newMessage:
      MessagePacket packet = data;
      MessageRepository.addMessage(packet);
      if (kDebugMode) {
        print("New message: ${packet.toMap()}");
      }
    case RadioEvents.weatherReport:
      throw UnimplementedError();
    case RadioEvents.radioSettingChanged:
      Future.delayed(const Duration(seconds: 2), () {
        settingChangeNotifier.value = RadioExtract.radio.radioSetting;
      });
      // CustomEvents.instance.dispatchEvent(AppEvents.radioSettingChanged);
      if (kDebugMode) {
        print(
          "Radio setting updated: ${RadioExtract.radio.radioSetting.toMap()}",
        );
      }
      break;
    case RadioEvents.aprsSettingChanged:
      if (kDebugMode) {
        print(
          "Aprs setting updated: ${RadioExtract.radio.aprsSetting.toMap()}",
        );
      }
      break;
    case RadioEvents.radioStatusChanged:
      Status st = data;
      statusChangeNotifier.value = st;
      // CustomEvents.instance.dispatchEvent(AppEvents.statusChange, value: st);
      if (kDebugMode) {
        print("Radio status changed: ${st.toMap()}");
      }
      break;
  }
}
