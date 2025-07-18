import 'dart:async';
import 'dart:convert';
import 'package:aprs/src/helpers/location_provider.dart'
    show determineGeoPosition, locationSettings;
import 'package:aprs/src/helpers/app.events.dart';
import 'package:aprs/src/helpers/utils.dart' show formatDateTime;
import 'package:aprs/src/model/model.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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

    await determineGeoPosition();

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
            Position position = await Geolocator.getCurrentPosition(
              locationSettings: locationSettings,
            );
            runScheduledTask(event.drrStore, position);
          },
        );
      }
    });

    DrrStore? drr = await getDrrConfig();
    if (drr != null) {
      eventBus.fire(DrrSettingChangeEvent(drr));
    }
  }

  static void runScheduledTask(DrrStore drr, Position location) async {
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

  static void sendPositionPacketToDrr(BeaconStore beacon) async {
    dynamic payload = {
      "type": "FeatureCollection",
      "features": [
        {
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
            "timestamp": beacon.timestamp,
          },
        },
      ],
    };

    try {
      var url = Uri.http(drrUrl, 'api/store-geojson');

      var response = await http.post(url, body: jsonEncode(payload));

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
    allPacketsToDrrSubs = eventBus.on<NewPositionEvent>().listen((event) {
      sendPositionPacketToDrr(event.position);
    });

    print("subscription complete");
  }
}
