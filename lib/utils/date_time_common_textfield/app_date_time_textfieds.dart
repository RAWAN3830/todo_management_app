import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'common_datetime_text_field.dart';

class SelectDateTime extends StatefulWidget {
  const SelectDateTime({super.key});

  @override
  _SelectDateTimeState createState() => _SelectDateTimeState();
}

class _SelectDateTimeState extends State<SelectDateTime> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Format date into "yMMMd" format
  String formatDate(DateTime? date) {
    try {
      return date != null
          ? DateFormat.yMMMd().format(date)
          : 'Select Date'; // e.g., "Jan 28, 2025"
    } catch (e) {
      return DateFormat.yMMMd().format(DateTime.now());
    }
  }

  // Format time into "h:mm a" format with lowercase "am/pm"
  String formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dateTime).toLowerCase(); // e.g., "3:34 pm"
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = formatDate(selectedDate);
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        timeController.text = formatTime(selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _pickDate(context),
            child: CommonDateTimeTextField(
              title: 'Date',
              hintText: formatDate(selectedDate),
              controller: dateController,
              readOnly: true,
              suffixIcon: IconButton(
                onPressed: () => _pickDate(context),
                icon: const Icon(Icons.date_range),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => _pickTime(context),
            child: CommonDateTimeTextField(
              title: 'Time',
              hintText: formatTime(selectedTime),
              controller: timeController,
              readOnly: true,
              suffixIcon: IconButton(
                onPressed: () => _pickTime(context),
                icon: const Icon(CupertinoIcons.clock_fill),
              ),
            ),
          ),
        ),
      ],
    );
  }
}