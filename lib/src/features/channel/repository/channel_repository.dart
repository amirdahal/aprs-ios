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
}
