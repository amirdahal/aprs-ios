import 'constants.dart';

dynamic toneStringToValue(String tone) {
  tone = tone.trim();
  if (tone.isEmpty || tone == "None") {
    return null;
  }

  if (tone.endsWith(" Hz")) {
    try {
      double f = double.parse(tone.split(' ')[0]);
      return f;
    } catch (e) {
      return null;
    }
  }

  if (tone.startsWith("DCS-")) {
    try {
      int f = int.parse(tone.substring(4, 7));
      return f;
    } catch (e) {
      return null;
    }
  }

  return null;
}

String getToneLabel(dynamic value) {
  if (value == null || value == "None") {
    return "None";
  }

  try {
    value = value.toString();
    String val = double.parse(value).toStringAsFixed(1);
    String valueStr = "$val Hz";
    if (tones.contains(valueStr)) {
      return valueStr;
    }
  } catch (e) {}

  try {
    int dcsCode = int.parse(value);
    for (var tone in tones) {
      if (tone.startsWith("DCS-") &&
          tone.substring(4, 7) == dcsCode.toStringAsExponential(3)) {
        return tone;
      }
    }
  } catch (e) {}

  return "None";
}

String? frequencyValidator(String? value) {
  if (value == null || value == "") {
    return 'Frequency is required';
  }
  try {
    double.parse(value);
  } catch (e) {
    return 'Frequency should be a number';
  }
  return null;
}
