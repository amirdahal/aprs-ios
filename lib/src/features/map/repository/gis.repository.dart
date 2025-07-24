import 'dart:convert';

import 'package:aprs/src/helpers/location_provider.dart';
import 'package:aprs/src/helpers/server.constants.dart';
import 'package:aprs/src/model/model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GisRepository {
  static String gisData = "";
  static DateTime? lastFetch;

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
      if (DateTime.now().difference(lastFetch!).inMinutes < 10) {
        return gisData;
      }
    }

    MyLocationProvider location = myLocationProvider.value!;

    var url = Uri.http(drrBaseUrl, 'api/gis-data', {
      'lat': location.latitude.toString(),
      'lng': location.longitude.toString(),
      'radius': '5',
    });

    var response = await http.get(
      url,
      headers: {'Authorization': '594f51b3b12a85c5a4367284b54724a71daa324d'},
    );
    gisData = response.body;
    lastFetch = DateTime.now();
    return gisData;
  }
}
