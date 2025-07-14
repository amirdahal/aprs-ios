import 'package:aprs/src/model/model.dart';
import 'package:custom_events/custom_events.dart';
import 'package:radio/radio.dart';

enum AprsEvents { newBeaconEvent }

class AprsLogRepository {
  static CustomEvents appEvent = CustomEvents.instance;

  static Future<void> savePacket(PositionPacket packet) async {
    BeaconStore newBeacon = BeaconStore(
      source: packet.source,
      comment: packet.comment,
      destination: packet.destination,
      latitude: packet.latitude,
      longitude: packet.longitude,
      path: packet.digipeaters.join(","),
      raw: packet.raw,
      symbol: packet.symbol,
      symbolTable: packet.symbolTable,
      timestamp: packet.timestamp,
    );

    newBeacon.saveOrThrow();
    appEvent.dispatchEvent(AprsEvents.newBeaconEvent, value: newBeacon);
  }

  static Future<List<BeaconStore>> getPackets({
    required String callsign,
    DateTime? start,
    DateTime? end,
  }) async {
    final query = BeaconStore().select().source.equals(callsign);

    if (start != null) {
      query.and.timestamp.greaterThanOrEquals(start);
    }
    if (end != null) {
      query.and.timestamp.lessThanOrEquals(end);
    }

    return await query.toList();
  }

  static Future<List<BeaconStore>> getUniquePackets() async {
    return await BeaconStore()
        .distinct(columnsToSelect: ['source'])
        .orderByDesc('timestamp')
        .toList();
  }
}
