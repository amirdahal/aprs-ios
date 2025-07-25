import 'package:event_bus/event_bus.dart';
import 'package:radio/radio.dart';
import 'package:smart_rf/src/model/model.dart' show BeaconStore, DrrStore;

EventBus eventBus = EventBus();

class NewMessageEvent {
  final String callsign;

  const NewMessageEvent(this.callsign);
}

class NewChatEvent {
  final String callsign;

  const NewChatEvent(this.callsign);
}

class NewPositionEvent {
  final BeaconStore position;

  const NewPositionEvent(this.position);
}

class StatusChangeEvent {
  final Status status;

  const StatusChangeEvent(this.status);
}

class RadioSettingChangeEvent {
  final RadioSetting radioSetting;

  const RadioSettingChangeEvent(this.radioSetting);
}

class AprsSettingChangeEvent {
  final AprsSetting aprsSetting;

  const AprsSettingChangeEvent(this.aprsSetting);
}

class DrrSettingChangeEvent {
  final DrrStore drrStore;

  const DrrSettingChangeEvent(this.drrStore);
}

class DeviceDisconnectedEvent {
  const DeviceDisconnectedEvent();
}
