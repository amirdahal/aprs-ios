import 'package:aprs/src/widgets/buttons.dart';
import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final String label;
  final void Function(DateTime dateTime) onDateTimeChanged;
  const DateTimePicker({
    super.key,
    this.initialDateTime,
    required this.onDateTimeChanged,
    required this.label,
  });

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime? _selectedDateTime;

  get label => widget.label;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime.timestamp(),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _selectedDateTime ?? DateTime.now(),
        ),
      );

      if (time != null) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        setState(() {
          _selectedDateTime = dateTime;
        });

        widget.onDateTimeChanged(dateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Button.outlined(
      onPressed: _pickDateTime,
      label: _selectedDateTime != null ? _selectedDateTime.toString() : label,
    );
  }
}
