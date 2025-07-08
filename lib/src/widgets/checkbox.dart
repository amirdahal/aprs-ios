import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final String label;
  final bool checked;
  final void Function(bool?)? onChanged;
  const CustomCheckbox({
    super.key,
    required this.checked,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(label),
      fillColor: WidgetStatePropertyAll(Colors.white),
      activeColor: Colors.green,
      checkColor: Colors.green,

      value: checked,
      onChanged: onChanged,
    );
  }
}
