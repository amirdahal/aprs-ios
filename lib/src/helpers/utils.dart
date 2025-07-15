import 'dart:io';

import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  return '${dateTime.year}-'
      '${twoDigits(dateTime.month)}-'
      '${twoDigits(dateTime.day)} '
      '${twoDigits(dateTime.hour)}:'
      '${twoDigits(dateTime.minute)}:'
      '${twoDigits(dateTime.second)}';
}

String formatTimestamp(dynamic timestamp, {bool min = false}) {
  if (timestamp == null) return '';
  final date = DateTime.tryParse(timestamp.toString());
  return date != null
      ? min
            ? DateFormat('HH:mm').format(date)
            : DateFormat('yyyy-MM-dd HH:mm:ss').format(date)
      : timestamp.toString();
}

final isLargeScreen =
    Platform.isWindows || Platform.isMacOS || Platform.isLinux;
