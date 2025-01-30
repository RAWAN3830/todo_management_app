import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../model/task_model/task_model.dart';
import '../services/responsive_breakpoint.dart';
import '../utils/common_widgets/common_heading.dart';
import '../utils/common_widgets/common_long_text_field.dart';
import '../utils/common_widgets/app_save_button.dart';
import '../utils/common_widgets/common_text_field.dart';
import '../utils/date_time_common_textfield/common_datetime_text_field.dart';
import '../view_model/task_provider.dart';

final titleControllerProvider = StateProvider.autoDispose((ref) => TextEditingController());
final noteControllerProvider = StateProvider.autoDispose((ref) => TextEditingController());
final dateControllerProvider = StateProvider.autoDispose((ref) => TextEditingController());
final timeControllerProvider = StateProvider.autoDispose((ref) => TextEditingController());
final selectedDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final selectedTimeProvider = StateProvider.autoDispose<TimeOfDay?>((ref) => null);

class AddTaskScreen extends ConsumerStatefulWidget {
  final TaskModel? task;

  const AddTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Initialize controllers with existing task data
        ref.read(titleControllerProvider.notifier).state.text = widget.task!.title;
        ref.read(noteControllerProvider.notifier).state.text = widget.task!.note;

        final date = DateTime.parse(widget.task!.date);
        ref.read(selectedDateProvider.notifier).state = date;
        ref.read(dateControllerProvider.notifier).state.text = formatDate(date);

        final time = TimeOfDay(
          hour: int.parse(widget.task!.time.split(':')[0]),
          minute: int.parse(widget.task!.time.split(':')[1]),
        );
        ref.read(selectedTimeProvider.notifier).state = time;
        ref.read(timeControllerProvider.notifier).state.text = formatTime(time);
      });
    }
  }

  void saveTask() {
    if (formKey.currentState!.validate()) {
      final titleController = ref.read(titleControllerProvider);
      final noteController = ref.read(noteControllerProvider);
      final selectedDate = ref.read(selectedDateProvider);
      final selectedTime = ref.read(selectedTimeProvider);

      final task = TaskModel(
        id: widget.task?.id,
        title: titleController.text,
        note: noteController.text,
        date: selectedDate?.toIso8601String().split('T')[0] ?? '',
        time: selectedTime != null ? '${selectedTime.hour}:${selectedTime.minute}' : '',
        isCompleted: widget.task?.isCompleted ?? false,
      );

      if (widget.task == null) {
        ref.read(taskListProvider.notifier).addTask(task).then((_) {
          Navigator.pop(context, true);
        });
      } else {
        ref.read(taskListProvider.notifier).updateTask(task).then((_) {
          Navigator.pop(context, true);
        });
      }
    }
  }

  String formatDate(DateTime? date) {
    try {
      return date != null
          ? DateFormat.yMMMd().format(date)
          : 'Select Date';
    } catch (e) {
      return DateFormat.yMMMd().format(DateTime.now());
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dateTime).toLowerCase();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: ref.read(selectedDateProvider) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      ref.read(selectedDateProvider.notifier).state = pickedDate;
      ref.read(dateControllerProvider.notifier).state.text = formatDate(pickedDate);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: ref.read(selectedTimeProvider) ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      ref.read(selectedTimeProvider.notifier).state = pickedTime;
      ref.read(timeControllerProvider.notifier).state.text = formatTime(pickedTime);
    }
  }

  Widget buildSelectDateTime() {
    final dateController = ref.watch(dateControllerProvider);
    final timeController = ref.watch(timeControllerProvider);

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
            return buildTabletLayout();
          } else {
            return buildPhoneLayout();
          }
        },
      ),
    );
  }

  Widget buildPhoneLayout() {
    final titleController = ref.watch(titleControllerProvider);
    final noteController = ref.watch(noteControllerProvider);

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const CommonHeading(title: 'Title'),
            CommonTextField(labelText: 'Enter title', controller: titleController, errorText: 'Title required'),
            buildSelectDateTime(),
            const SizedBox(height: 10),
            const CommonHeading(title: 'Notes'),
            CommonLongTextField(controller: noteController, hintText: 'Enter notes here', errorText: 'Notes required'),
            const SizedBox(height: 10),
            AppSaveButton(formKey: formKey, onTap: saveTask, name: 'Save'),
          ],
        ),
      ),
    );
  }

  Widget buildTabletLayout() {
    final titleController = ref.watch(titleControllerProvider);
    final noteController = ref.watch(noteControllerProvider);

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
                      const CommonHeading(title: 'Title'),
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
            const CommonHeading(title: 'Notes'),
            CommonLongTextField(controller: noteController, hintText: 'Enter notes here', errorText: 'Notes required'),
            const SizedBox(height: 20),
            AppSaveButton(formKey: formKey, onTap: saveTask, name: 'Save'),
          ],
        ),
      ),
    );
  }
}