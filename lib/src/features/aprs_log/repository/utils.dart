import 'package:radio/radio.dart';
import 'package:drr_radio_tracker/src/model/model.dart';

PositionPacket beaconStoreToPositionPacket(BeaconStore beacon) {
  return PositionPacket(
    timestamp: beacon.timestamp!,
    source: beacon.source!,
    destination: beacon.destination!,
    digipeaters: beacon.path!.split('.'),
    latitude: beacon.latitude!,
    longitude: beacon.longitude!,
    comment: beacon.comment!,
    symbolTable: beacon.symbolTable!,
    symbol: beacon.symbol!,
    raw: beacon.raw!,
  );
}
