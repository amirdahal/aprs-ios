import 'package:aprs/src/features/aprs_log/repository/aprs-log.repository.dart';
import 'package:aprs/src/features/message/repository/message.repository.dart';
import 'package:aprs/src/helpers/app.events.dart';
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

ValueNotifier<Status> statusChangeNotifier = ValueNotifier<Status>(
  RadioExtract.radio.status,
);

ValueNotifier<RadioSetting> settingChangeNotifier = ValueNotifier<RadioSetting>(
  RadioExtract.radio.radioSetting,
);

void radioEventsHandler(RadioEvents eventType, dynamic data) {
  switch (eventType) {
    case RadioEvents.newBeacon:
      PositionPacket packet = data;
      var packets = aprsPositionPackets.value.toList();
      packets.add(data);
      aprsPositionPackets.value = packets;
      AprsLogRepository.savePacket(packet);
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
      RadioSetting setting = data;
      if (kDebugMode) {
        print("Setting changed event in app: ${setting.toMap()}");
      }
      settingChangeNotifier.value = setting;
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
      break;
    case RadioEvents.deviceDisconnected:
      debugPrint('Device disconnected success');
      eventBus.fire(DeviceDisconnectedEvent());
      break;
  }
}
