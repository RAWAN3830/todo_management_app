import 'package:flutter/material.dart';
import 'package:task_management_app/utils/extensions.dart';

import '../model/task_model.dart';
import '../services/database_connection.dart';
import '../utils/date_time_common_textfield/app_date_time_textfieds.dart';
import '../utils/common_heading.dart';
import '../utils/common_long_text_field.dart';
import '../utils/app_save_button.dart';
import '../utils/common_text_field.dart';

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
  String selectedDate = '';
  String selectedTime = '';

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      noteController.text = widget.task!.note;
      selectedDate = widget.task!.date;
      selectedTime = widget.task!.time;
    }
  }

  void saveTask() {
    if (formKey.currentState!.validate()) {
      final task = TaskModel(
        id: widget.task?.id,
        title: titleController.text,
        note: noteController.text,
        date: selectedDate,
        time: selectedTime,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Add Task' : 'Update Task')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Tablet layout
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
            SelectDateTime(),
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
                  child: SelectDateTime(),
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