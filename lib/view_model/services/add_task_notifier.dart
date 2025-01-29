import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import '../../model/task_model.dart';
import '../../services/database_connection.dart';
import '../../utils/task_utils.dart';

class TaskNotifier extends StateNotifier<TaskModel?> {
  TaskNotifier(TaskModel? initialTask) : super(initialTask) {
    initializeTask(initialTask);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void initializeTask(TaskModel? task) {
    if (task != null) {
      titleController.text = task.title;
      noteController.text = task.note;
      selectedDate = DateTime.tryParse(task.date);
      selectedTime = parseTime(task.time);
      dateController.text = formatDate(selectedDate);
      timeController.text = formatTime(selectedTime);
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      selectedDate = pickedDate;
      dateController.text = formatDate(selectedDate);
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      selectedTime = pickedTime;
      timeController.text = formatTime(selectedTime);
    }
  }

  Future<void> saveTask(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final task = TaskModel(
      id: state?.id,
      title: titleController.text,
      note: noteController.text,
      date: selectedDate?.toIso8601String().split('T')[0] ?? '',
      time: selectedTime != null ? '${selectedTime!.hour}:${selectedTime!.minute}' : '',
      isCompleted: state?.isCompleted ?? false,
    );

    if (state == null) {
      await DatabaseRepo.insertRecord(task);
    } else {
      await DatabaseRepo.updateRecord(task);
    }

    Navigator.pop(context, true);
  }
}

final taskProvider = StateNotifierProvider.family<TaskNotifier, TaskModel?, TaskModel?>(
      (ref, task) => TaskNotifier(task),
);