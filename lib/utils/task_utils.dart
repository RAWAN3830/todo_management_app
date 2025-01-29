import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  return date != null ? DateFormat.yMMMd().format(date) : 'Select Date';
}

String formatTime(TimeOfDay? time) {
  if (time == null) return 'Select Time';
  final now = DateTime.now();
  final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('h:mm a').format(dateTime).toLowerCase();
}

TimeOfDay? parseTime(String? timeString) {
  if (timeString == null || timeString.isEmpty) return null;
  final parts = timeString.split(':');
  if (parts.length != 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  return TimeOfDay(hour: hour, minute: minute);
}