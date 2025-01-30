import 'package:flutter/material.dart';
import 'package:task_management_app/utils/common_widgets/extensions.dart';

import '../../model/task_model/task_model.dart';

class TaskDetails extends StatelessWidget {
  final TaskModel task;

  const TaskDetails({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(context.height(context) * 0.1),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            task.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Date: ${task.date}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Time: ${task.time}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Notes:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            task.note,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}