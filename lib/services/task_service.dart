import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/task_model/task_model.dart';
import 'database_connection.dart';

class TaskService extends StateNotifier<List<TaskModel>> {
  TaskService() : super([]) {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final tasks = await DatabaseRepo.getRecords();
    state = tasks;
  }

  void addTask(TaskModel task) async {
    await DatabaseRepo.insertRecord(task);
    fetchTasks();
  }

  void updateTask(TaskModel task) async {
    await DatabaseRepo.updateRecord(task);
    fetchTasks();
  }

  void removeTask(int id) async {
    await DatabaseRepo.deleteRecord(id);
    fetchTasks();
  }

  void toggleTaskCompletion(TaskModel task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await DatabaseRepo.updateRecord(updatedTask);
    fetchTasks();
  }
}

final taskServiceProvider = StateNotifierProvider<TaskService, List<TaskModel>>((ref) {
  return TaskService();
});