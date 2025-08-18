import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:drr_radio_tracker/src/helpers/location_provider.dart';
import 'package:drr_radio_tracker/src/helpers/server.constants.dart';
import 'package:drr_radio_tracker/src/model/model.dart';

class GisRepository {
  static String gisData = "";
  static DateTime? lastFetch;

  // ignore: unused_element
  Future<void> _fetchAndSaveWarehouses() async {
    var uri = Uri.http(drrBaseUrl, 'api/warehouses');
    final res = await http.get(
      uri,
      headers: {'Authorization': '594f51b3b12a85c5a4367284b54724a71daa324d'},
    );
    final body = jsonDecode(res.body);
    List<dynamic> data = body["data"];
    for (var d in data) {
      if (d["latitude"] != null && d["longitude"] != null) {
        try {
          Warehouse(
            name: d["name"],
            address: d["address"],
            latitude: double.tryParse(d["latitude"]),
            longitude: double.tryParse(d["longitude"]),
          ).saveOrThrow();
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    }
  }

  Future<void> _fetchAndSaveEvacuationCentres() async {
    var uri = Uri.http(drrBaseUrl, 'api/evacuation-centers');
    final res = await http.get(
      uri,
      headers: {'Authorization': '594f51b3b12a85c5a4367284b54724a71daa324d'},
    );
    final body = jsonDecode(res.body);
    List<dynamic> data = body["data"];
    for (var d in data) {
      if (d["latitude"] != null && d["longitude"] != null) {
        try {
          EvacuationCentre(
            name: d["name"],
            address: d["address"],
            latitude: double.tryParse(d["latitude"]),
            longitude: double.tryParse(d["longitude"]),
            capacity: int.tryParse(d["capacity"]),
          ).saveOrThrow();
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    }
  }

  static Future<void> loadServerData() async {
    GisRepository repo = GisRepository();

    await repo._fetchAndSaveEvacuationCentres();
    // await repo._fetchAndSaveWarehouses();
  }

  static Future<String?> loadGisData() async {
    if (lastFetch != null) {
      if (DateTime.now().difference(lastFetch!).inSeconds < 30) {
        return gisData;
      }
    }

    MyLocationProvider location = myLocationProvider.value!;

    Uri url;

    if (kDebugMode) {
      url = Uri.http(drrBaseUrl, 'api/gis-data', {
        'lat': '12.3511',
        'lng': '125.0071',
        'radius': '10',
      });
    } else {
      url = Uri.http(drrBaseUrl, 'api/gis-data', {
        'lat': location.latitude.toString(),
        'lng': location.longitude.toString(),
        'radius': '5',
      });
    }

    var response = await http.get(
      url,
      headers: {'Authorization': '594f51b3b12a85c5a4367284b54724a71daa324d'},
    );

    gisData = response.body;
    lastFetch = DateTime.now();
    return gisData;
  }
}
