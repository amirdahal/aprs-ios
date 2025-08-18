import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:drr_radio_tracker/src/features/aprs_log/repository/aprs-log.repository.dart';
import 'package:drr_radio_tracker/src/helpers/app.events.dart';
import 'package:drr_radio_tracker/src/helpers/location_provider.dart'
    show MyLocationProvider, myLocationProvider;
import 'package:drr_radio_tracker/src/helpers/utils.dart' show formatDateTime;
import 'package:drr_radio_tracker/src/model/model.dart';

class DrrRepository {
  static String get drrUrl => '24.222.96.163:9060';

  static StreamSubscription? allPacketsToDrrSubs;

  static Future<DrrStore?> getDrrConfig() async {
    return await DrrStore().getById(1);
  }

  static void setDrrConfig(DrrStore drrStore) async {
    await drrStore.save();
    eventBus.fire(DrrSettingChangeEvent(drrStore));
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

    StreamSubscription _ = eventBus.on<DrrSettingChangeEvent>().listen((event) {
      if (kDebugMode) {
        print("Drr config change event received");
      }

      if (allPacketsToDrrSubs != null) {
        allPacketsToDrrSubs?.cancel();
      }

      if (event.drrStore.sendAllPositions!) {
        allPacketsToDrr();
      }

      intervalTimer?.cancel();
      if (event.drrStore.sendMyPosition!) {
        intervalTimer = Timer.periodic(
          Duration(minutes: event.drrStore.interval!),
          (timer) async {
            MyLocationProvider? myLocation = myLocationProvider.value;
            if (myLocation != null) {
              runScheduledTask(event.drrStore, myLocation);
            }
          },
        );
      }
    });

    DrrStore? drr = await getDrrConfig();
    if (drr != null) {
      eventBus.fire(DrrSettingChangeEvent(drr));
    }
  }

  static void runScheduledTask(
    DrrStore drr,
    MyLocationProvider location,
  ) async {
    DateTime now = DateTime.now();

    try {
      var url = Uri.http(drrUrl, 'api/aprs-device-location/${drr.uuid}');

      var response = await http.post(
        url,
        body: {
          'latitude': location.latitude.toString(),
          'longitude': location.longitude.toString(),
          'altitude': location.altitude != null
              ? location.altitude.toString()
              : '0.0',
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

  static Future<void> sendPositionPacketToDrr(BeaconStore beacon) async {
    List<BeaconStore> unsentPackets = await AprsLogRepository.getPacketToDrr();
    if (unsentPackets.isEmpty) {
      return;
    }

    List<dynamic> features = [];

    for (var beacon in unsentPackets) {
      features.add({
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": [beacon.latitude, beacon.longitude],
        },
        "properties": {
          "source": beacon.source,
          "destination": beacon.destination,
          "comment": beacon.comment,
          "raw": beacon.raw,
          "path": beacon.path,
          "timestamp": beacon.timestamp?.toIso8601String(),
        },
      });
    }

    dynamic payload = {"type": "FeatureCollection", "features": features};

    try {
      var url = Uri.http(drrUrl, 'api/store-geojson');

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        await AprsLogRepository.markPacketsAsSentToDrr(unsentPackets);
      }

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Send all position to drr error: $e");
      }
    }
  }

  static void allPacketsToDrr() async {
    if (kDebugMode) {
      print("Send all packets to drr");
    }
    allPacketsToDrrSubs = eventBus.on<NewPositionEvent>().listen((event) {
      sendPositionPacketToDrr(event.position);
    });
  }
}
