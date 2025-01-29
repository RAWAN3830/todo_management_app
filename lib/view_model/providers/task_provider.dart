import 'package:riverpod/riverpod.dart';
import '../../model/task_model.dart';
import '../../services/database_connection.dart';


class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier() : super([]);

  Future<void> fetchTasks() async {
    final tasks = await DatabaseRepo.getRecords();
    state = tasks;
  }

  Future<void> addTask(TaskModel task) async {
    await DatabaseRepo.insertRecord(task);
    fetchTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await DatabaseRepo.updateRecord(task);
    fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseRepo.deleteRecord(id);
    fetchTasks();
  }
}

// Providers
final taskProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  return TaskNotifier()..fetchTasks();
});

final toDoProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.where((task) => !task.isCompleted).toList();
});

final completedProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.where((task) => task.isCompleted).toList();
});