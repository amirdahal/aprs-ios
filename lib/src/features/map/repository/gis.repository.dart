import 'dart:convert';

import 'package:aprs/src/helpers/server.constants.dart';
import 'package:aprs/src/model/model.dart';
import 'package:http/http.dart' as http;

class GisRepository {
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
          print(e);
        }
      }
    }

    print(Warehouse().select().toList());
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
          print(e);
        }
      }
    }

    print(EvacuationCentre().select().toList());
  }

  static Future<void> loadServerData() async {
    GisRepository repo = GisRepository();

    await repo._fetchAndSaveEvacuationCentres();
    await repo._fetchAndSaveWarehouses();
  }
}
