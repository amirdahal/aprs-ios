import 'package:flutter/material.dart';

import '../helpers/theme.dart';

class DropDown extends StatelessWidget {
  final void Function(String?)? onChanged;
  final String? Function(dynamic)? validator;
  final List<String> options;
  final String selectedValue;
  final String label;

  const DropDown({
    super.key,
    required this.onChanged,
    required this.options,
    required this.selectedValue,
    required this.label,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: inputDecoration(label),
      dropdownColor: Colors.white,
      // menuMaxHeight: 30,
      value: selectedValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: options.map((val) {
        return DropdownMenuItem(value: val, child: Text(val));
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
