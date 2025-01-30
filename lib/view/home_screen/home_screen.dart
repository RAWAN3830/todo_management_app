import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/task_model/task_model.dart';
import '../../view_model/task_provider.dart';
import '../add_task_screen.dart';
import 'task_details.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void navigateToAddTaskScreen(BuildContext context, {TaskModel? task}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(task: task),
      ),
    );
    if (result == true) {
      // The provider will handle the refresh
    }
  }

  void showTaskDetails(BuildContext context, TaskModel task) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TaskDetails(task: task);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoTasks = ref.watch(todoTasksProvider);
    final completedTasks = ref.watch(completedTasksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo app Screen')),
      body: Column(
        children: [
          Expanded(
            child: todoTasks.when(
              data: (tasks) => ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text('${task.date} - ${task.time}'),
                    onTap: () => showTaskDetails(context, task),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => navigateToAddTaskScreen(context, task: task),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => ref.read(taskListProvider.notifier).deleteTask(task.id!),
                        ),
                        Checkbox(
                          value: task.isCompleted,
                          onChanged: (bool? value) {
                            if (value != null) {
                              ref.read(taskListProvider.notifier).toggleTaskStatus(task);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
          const Divider(),
          const Text('Completed Tasks', style: TextStyle(fontSize: 18)),
          Expanded(
            child: completedTasks.when(
              data: (tasks) => ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text('${task.date} - ${task.time}'),
                    onTap: () => showTaskDetails(context, task),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => navigateToAddTaskScreen(context, task: task),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => ref.read(taskListProvider.notifier).deleteTask(task.id!),
                        ),
                        Checkbox(
                          value: task.isCompleted,
                          onChanged: (bool? value) {
                            if (value != null) {
                              ref.read(taskListProvider.notifier).toggleTaskStatus(task);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAddTaskScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}