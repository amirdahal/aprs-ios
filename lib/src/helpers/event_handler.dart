import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:flutter/foundation.dart';
import 'package:radio/radio.dart';

ValueNotifier<Status?> statusNotifier = ValueNotifier(null);

void radioEventsHandler(RadioEvents eventType, dynamic data) {
  switch (eventType) {
    case RadioEvents.newBeacon:
      PositionPacket packet = data;
      if (kDebugMode) {
        print("New beacon: ${packet.toMap()}");
      }
    case RadioEvents.newMessage:
      MessagePacket packet = data;
      if (kDebugMode) {
        print("New message: ${packet.toMap()}");
      }
    case RadioEvents.weatherReport:
      throw UnimplementedError();
    case RadioEvents.radioSettingChanged:
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
      statusNotifier.value = st;
      if (kDebugMode) {
        print("Radio status changed: ${st.toMap()}");
      }
      break;
  }
}
