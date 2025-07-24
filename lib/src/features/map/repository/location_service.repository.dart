import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationRepository {

  Uri _getUri({required double lat, required double lng}) {
    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    String appleMapsUrl =
        'https://maps.apple.com/?q=$lat,$lng';

    return Uri.parse(
      Platform.isIOS || Platform.isMacOS
          ? appleMapsUrl
          : googleMapsUrl,
    );
  }

  static Future<void> openInMap({required double lat, required double lng}) async {

    await launchUrl(LocationRepository()._getUri(lat: lat, lng: lng));
  }

  static Future<void> sharePosition({required double lat, required double lng, String name = "", String address = ""}) async {
    await SharePlus.instance.share(
      ShareParams(
        title: '$name $address',
        subject: '$name $address',
        uri: LocationRepository()._getUri(lat: lat, lng: lng),
      ),
    );
  }

}