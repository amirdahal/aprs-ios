import 'package:flutter/material.dart';

class Button {
  static ButtonStyle primaryStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static ButtonStyle outlinedStyle = OutlinedButton.styleFrom(
    foregroundColor: Colors.green,
    side: const BorderSide(color: Colors.green),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static ButtonStyle textStyle = TextButton.styleFrom(
    foregroundColor: Colors.green,
    textStyle: const TextStyle(fontWeight: FontWeight.w600),
  );

  static Widget primary({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
      label: Text(label),
      style: primaryStyle,
    );
  }

  static Widget outlined({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
      label: Text(label),
      style: outlinedStyle,
    );
  }

  static Widget text({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
      style: textStyle,
    );
  }

  static Widget icon({
    required IconData icon,
    required VoidCallback onPressed,
    bool filled = true,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: filled ? Colors.green : null,
        foregroundColor: filled ? Colors.white : Colors.green,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
