import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/task_model/task_model.dart';
import '../services/database_connection.dart';

// Provider for all tasks
final taskListProvider = StateNotifierProvider<TaskNotifier, AsyncValue<List<TaskModel>>>(
      (ref) => TaskNotifier(),
);

// Provider for filtered todo tasks
final todoTasksProvider = Provider<AsyncValue<List<TaskModel>>>((ref) {
  return ref.watch(taskListProvider).whenData(
        (tasks) => tasks.where((task) => !task.isCompleted).toList(),
  );
});

// Provider for filtered completed tasks
final completedTasksProvider = Provider<AsyncValue<List<TaskModel>>>((ref) {
  return ref.watch(taskListProvider).whenData(
        (tasks) => tasks.where((task) => task.isCompleted).toList(),
  );
});

class TaskNotifier extends StateNotifier<AsyncValue<List<TaskModel>>> {
  TaskNotifier() : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      state = const AsyncValue.loading();
      final tasks = await DatabaseRepo.getRecords();
      state = AsyncValue.data(tasks);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await DatabaseRepo.insertRecord(task);
      await loadTasks();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await DatabaseRepo.updateRecord(task);
      await loadTasks();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await DatabaseRepo.deleteRecord(id);
      await loadTasks();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> toggleTaskStatus(TaskModel task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await DatabaseRepo.updateRecord(updatedTask);
      await loadTasks();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}