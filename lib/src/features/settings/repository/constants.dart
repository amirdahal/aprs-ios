// Radio Settings
import 'package:aprs/src/helpers/radio_extract.dart' show RadioExtract;

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
