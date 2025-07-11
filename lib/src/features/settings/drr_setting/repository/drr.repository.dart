import 'dart:async';

import 'package:aprs/src/features/map/repository/location_provider.dart'
    show determinePosition;
import 'package:aprs/src/features/message/repository/message.repository.dart'
    show MyEvents;
import 'package:aprs/src/helpers/utils.dart' show formatDateTime;
import 'package:aprs/src/model/model.dart';
import 'package:custom_events/custom_events.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class DrrRepository {
  static String get drrUrl => '24.222.96.163:9060';

  static CustomEvents appEvent = CustomEvents.instance;

  static Future<DrrStore?> getDrrConfig() async {
    return await DrrStore().getById(1);
  }

  static void setDrrConfig(DrrStore drrStore) async {
    await drrStore.save();
    appEvent.dispatchEvent(MyEvents.drrSettingChangedEvent, value: drrStore);
  }

  static Future<void> seedDrr() async {
    int drrCount = await DrrStore().select().toCount();
    if (drrCount < 1) {
      await DrrStore(
        sendMyPosition: false,
        comment: '',
        interval: 30,
        uuid: '',
      ).save();
    }
  }

  static void startDrr() async {
    Timer? intervalTimer;
    Location location = await determinePosition();

    appEvent.addEventListener(MyEvents.drrSettingChangedEvent, (DrrStore drr) {
      if (kDebugMode) {
        print("Drr config change event received");
      }
      intervalTimer?.cancel();
      if (drr.sendMyPosition!) {
        intervalTimer = Timer.periodic(Duration(minutes: drr.interval!), (
          timer,
        ) async {
          LocationData loc = await location.getLocation();
          runScheduledTask(drr, loc);
        });
      }
    });

    DrrStore? drr = await getDrrConfig();
    if (drr != null) {
      appEvent.dispatchEvent(MyEvents.drrSettingChangedEvent, value: drr);
    }
  }

  static void runScheduledTask(DrrStore drr, LocationData location) async {
    if (kDebugMode) {
      print("Send position to DRR");
    }

    DateTime now = DateTime.now();

    try {
      var url = Uri.http(drrUrl, 'api/aprs-device-location/${drr.uuid}');

      var response = await http.post(
        url,
        body: {
          'latitude': location.latitude.toString(),
          'longitude': location.longitude.toString(),
          'altitude': location.altitude.toString(),
          'comment': drr.comment,
          'recorded_at': formatDateTime(now),
        },
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Send drr error: $e");
      }
    }
  }
}
