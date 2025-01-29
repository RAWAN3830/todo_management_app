import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/task_model.dart';
import '../services/database_connection.dart';
import '../services/responsive_breakpoint.dart';
import '../utils/common_heading.dart';
import '../utils/common_long_text_field.dart';
import '../utils/app_save_button.dart';
import '../utils/common_text_field.dart';
import '../utils/date_time_common_textfield/common_datetime_text_field.dart';


class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      noteController.text = widget.task!.note;
      selectedDate = DateTime.parse(widget.task!.date);
      selectedTime = TimeOfDay(
        hour: int.parse(widget.task!.time.split(':')[0]),
        minute: int.parse(widget.task!.time.split(':')[1]),
      );
      dateController.text = formatDate(selectedDate);
      timeController.text = formatTime(selectedTime);
    }
  }

  void saveTask() {
    if (formKey.currentState!.validate()) {
      final task = TaskModel(
        id: widget.task?.id,
        title: titleController.text,
        note: noteController.text,
        date: selectedDate?.toIso8601String().split('T')[0] ?? '',
        time: selectedTime != null ? '${selectedTime!.hour}:${selectedTime!.minute}' : '',
        isCompleted: widget.task?.isCompleted ?? false,
      );
      if (widget.task == null) {
        DatabaseRepo.insertRecord(task).then((_) {
          Navigator.pop(context, true);
        });
      } else {
        DatabaseRepo.updateRecord(task).then((_) {
          Navigator.pop(context, true);
        });
      }
    }
  }

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

  Widget buildSelectDateTime() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _pickDate(context),
            child: CommonDateTimeTextField(
              title: 'Date',
              hintText: dateController.text.isEmpty ? 'Select Date' : dateController.text,
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
              hintText: timeController.text.isEmpty ? 'Select Time' : timeController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Add Task' : 'Update Task')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (Responsive.isTablet(context) || Responsive.isDesktop(context)) {
            // Tablet or Desktop layout
            return buildTabletLayout();
          } else {
            // Phone layout
            return buildPhoneLayout();
          }
        },
      ),
    );
  }

  Widget buildPhoneLayout() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            CommonHeading(title: 'Title'),
            CommonTextField(labelText: 'Enter title', controller: titleController, errorText: 'Title required'),
            buildSelectDateTime(),
            const SizedBox(height: 10),
            CommonHeading(title: 'Notes'),
            CommonLongTextField(controller: noteController, hintText: 'Enter notes here', errorText: 'Notes required'),
            const SizedBox(height: 10),
            AppSaveButton(formKey: formKey, onTap: saveTask, name: 'Save'),
          ],
        ),
      ),
    );
  }

  Widget buildTabletLayout() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonHeading(title: 'Title'),
                      CommonTextField(labelText: 'Enter title', controller: titleController, errorText: 'Title required'),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: buildSelectDateTime(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CommonHeading(title: 'Notes'),
            CommonLongTextField(controller: noteController, hintText: 'Enter notes here', errorText: 'Notes required'),
            const SizedBox(height: 20),
            AppSaveButton(formKey: formKey, onTap: saveTask, name: 'Save'),
          ],
        ),
      ),
    );
  }
}