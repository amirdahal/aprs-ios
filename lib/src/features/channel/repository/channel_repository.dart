import 'package:aprs/src/helpers/radio_extract.dart';
import 'package:radio/radio.dart';

enum ChannelOption { channelA, channelB }

class ChannelRepository {
  static Future<ReplyStatus> updateChannel(RfChannel channel) async {
    try {
      return await RadioExtract.radio.setChannel(channel);
    } on Exception catch (e) {
      throw Exception("Channel update failed: $e");
    }
  }

  static Future<void> setChannelAorB({
    required ChannelOption option,
    required int channelId,
  }) async {
    RadioSetting newSetting = RadioExtract.radio.radioSetting.copyWith();
    if (option == ChannelOption.channelA) {
      newSetting.channelA = channelId;
    }
    if (option == ChannelOption.channelB) {
      newSetting.channelB = channelId;
    }

    await RadioExtract.radio.setRadioSettings(newSetting);
  }

  static Future<void> updateRadioSettings({
    required bool scan,
    required int doubleChannel,
    required bool powerSavingMode,
    required int squelchLevel,
    required bool audioRelay,
  }) async {
    RadioSetting newSetting = RadioExtract.radio.radioSetting.copyWith();
    newSetting.squelchLevel = squelchLevel;
    newSetting.doubleChannel = doubleChannel;
    newSetting.powerSavingMode = powerSavingMode;
    newSetting.scan = scan;

    if (newSetting.autoRelayEn != audioRelay) {
      newSetting.autoRelayEn = audioRelay;

      if (audioRelay) {
        newSetting.channelA = 28;
        newSetting.channelB = 29;
        newSetting.doubleChannel = 1;
      } else {
        newSetting.channelA = 27;
        newSetting.channelB = 29;
        newSetting.doubleChannel = 1;
      }
    }
    await RadioExtract.radio.setRadioSettings(newSetting);
  }
}
