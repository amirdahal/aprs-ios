import 'package:radio/radio.dart';
import 'package:drr_radio_tracker/src/features/settings/repository/default.dart';
import 'package:drr_radio_tracker/src/helpers/radio_extract.dart';

class SettingRepository {
  static Future<void> useDefaultRadioSetting() async {
    await RadioExtract.radio.setRadioSettings(defaultRadioSetting);
  }

  static Future<void> useDefaultAprsSetting() async {
    AprsSetting defaultSetting = defaultAprsSetting.copyWith();
    defaultSetting.aprsSsid = RadioExtract.radio.aprsSetting.aprsSsid;
    defaultSetting.aprsCallsign = RadioExtract.radio.aprsSetting.aprsCallsign;

    await RadioExtract.radio.setAprsSettings(defaultSetting);
  }

  static Future<void> useDefaultChannels() async {
    for (var channel in defaultChannels) {
      await RadioExtract.radio.setChannel(channel);
    }
  }

  static Future<int> setDefault() async {
    await useDefaultChannels();
    await useDefaultAprsSetting();
    await useDefaultRadioSetting();
    return 1;
  }
}
