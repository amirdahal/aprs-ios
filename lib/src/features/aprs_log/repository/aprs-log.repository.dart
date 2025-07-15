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

    query.orderByDesc('timestamp');

    return await query.toList();
  }

  static Future<List<BeaconStore>> getUniquePackets() async {
    return await BeaconStore()
        .select()
        .where('''
        id IN (
          SELECT id FROM beaconStore 
          GROUP BY source 
          HAVING MAX(timestamp)
        )
        ''')
        .orderByDesc('timestamp')
        .toList();
  }

  static List<BeaconStore> getUniquePositions(List<BeaconStore> allPackets) {
    final Map<String, BeaconStore> uniqueLocations = {};

    for (final packet in allPackets) {
      // Create a unique key from latitude and longitude (rounded to 6 decimal places)
      final locationKey =
          '${packet.latitude?.toStringAsFixed(6)}_${packet.longitude?.toStringAsFixed(6)}';

      // If we haven't seen this location before, or this packet is newer, store it
      if (!uniqueLocations.containsKey(locationKey) ||
          (packet.timestamp != null &&
              uniqueLocations[locationKey]!.timestamp != null &&
              packet.timestamp!.isAfter(
                uniqueLocations[locationKey]!.timestamp!,
              ))) {
        uniqueLocations[locationKey] = packet;
      }
    }

    // Convert the map values to a list and sort by timestamp (descending)
    final result = uniqueLocations.values.toList();
    result.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
    return result;
  }
}
