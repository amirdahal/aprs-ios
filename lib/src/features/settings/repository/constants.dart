// Radio Settings
import 'package:radio/radio.dart';
import 'package:drr_radio_tracker/src/helpers/radio_extract.dart' show RadioExtract;

final Map<String, int> doubleChanOptions = {"Off": 0, "A": 1, "B": 2};
final List<String> channelOptions = List.generate(
  RadioExtract.radio.deviceInfo.channelCount,
  (i) => 'Channel $i',
);
final Map<String, int> callModeOptions = {"Enabled": 1, "Disabled": 0};
final Map<String, int> micGainOptions = {"Low": 2, "Medium": 3, "High": 4};
final Map<String, int> btMicGainOptions = {"Low": 3, "Medium": 4, "High": 5};
final Map<String, int> localSpeakerOptions = {"Auto": 0, "On": 1, "Off": 2};
final Map<String, int> headphoneModeOptions = {"Voice mode": 0, "Call mode": 1};
final Map<String, int> autoPowerOffOptions = {
  "Off": 0,
  "15 minutes": 1,
  "30 minutes": 2,
  "1 hour": 3,
  "2 hours": 4,
  "4 hours": 5,
  "8 hours": 6,
  "16 hours": 7,
};

final List<String> txTimeLimitOptions = List.generate(
  31,
  (index) => index == 0 ? 'Unlimited' : '${index * 10} seconds',
);

final List<String> txHoldTimeOptions = List.generate(
  11,
  (index) => index == 0
      ? 'Off'
      : (index * 0.1) == 1.0
      ? '1 second'
      : '${(index * 0.1).toStringAsFixed(1)} second',
);

final Map<String, int> hmSpeakerOptions = {
  "Auto": 0,
  "On": 1,
  "Off": 2,
  "Sq": 3,
};

final Map<String, int> wxModeOptions = {'Off': 0, 'Monitor': 1, 'Alert': 2};
final Map<String, int> wxChannelOptions = {
  'WX1 - 162.550 MHz': 0,
  'WX2 - 162.400 MHz': 1,
  'WX3 - 162.475 MHz': 2,
  'WX4 - 162.425 MHz': 3,
  'WX5 - 162.450 MHz': 4,
  'WX6 - 162.500 MHz': 5,
  'WX7 - 162.525 MHz': 6,
};

//Aprs Settings
final Map<String, PacketFormat> packetFormatOptions = {
  'APRS': PacketFormat.aprs,
  'BSS': PacketFormat.bss,
};

final List<String> ssidOptions = List.generate(15, (i) => (i + 1).toString());

final Map<String, int> locationShareIntervalOptions = {
  'Off': 0,
  'Every 10 seconds': 10,
  'Every 20 seconds': 20,
  'Every 30 seconds': 30,
  'Every 40 seconds': 40,
  'Every 50 seconds': 50,
  'Every 1 minute': 60,
  'Every 2 minutes': 120,
  'Every 3 minutes': 180,
  'Every 4 minutes': 240,
  'Every 5 minutes': 300,
  'Every 6 minutes': 360,
  'Every 7 minutes': 420,
  'Every 8 minutes': 480,
  'Every 9 minutes': 540,
  'Every 10 minutes': 600,
  'Every 15 minutes': 900,
  'Every 20 minutes': 1200,
  'Every 25 minutes': 1500,
  'Every 30 minutes': 1800,
};
