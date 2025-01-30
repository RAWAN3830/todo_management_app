import 'package:flutter/material.dart';
import '../../model/task_model/task_model.dart';
import '../../services/database_connection.dart';
import '../add_task_screen.dart';
import 'task_details.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> toDoList = [];
  List<TaskModel> completedList = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    final tasks = await DatabaseRepo.getRecords();
    setState(() {
      toDoList = tasks.where((task) => !task.isCompleted).toList();
      completedList = tasks.where((task) => task.isCompleted).toList();
    });
  }

  void updateTaskStatus(TaskModel task, bool isCompleted) {
    final updatedTask = task.copyWith(isCompleted: isCompleted);
    DatabaseRepo.updateRecord(updatedTask).then((_) {
      fetchTasks();
    });
  }

  void deleteTask(int id) {
    DatabaseRepo.deleteRecord(id).then((_) {
      fetchTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task Deleted Successfully!')),
      );
    });
  }

  void navigateToAddTaskScreen({TaskModel? task}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(task: task),
      ),
    );
    if (result == true) {
      fetchTasks();
    }
  }

  void showTaskDetails(TaskModel task) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TaskDetails(task: task);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo app Screen')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return buildListLayout();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAddTaskScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildListLayout() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: toDoList.length,
            itemBuilder: (context, index) {
              final task = toDoList[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text('${task.date} - ${task.time}'),
                onTap: () => showTaskDetails(task), // Show task details on tap
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => navigateToAddTaskScreen(task: task),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteTask(task.id!),
                    ),
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? value) {
                        if (value != null) {
                          updateTaskStatus(task, value);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const Divider(),
        const Text('Completed Tasks', style: TextStyle(fontSize: 18)),
        Expanded(
          child: ListView.builder(
            itemCount: completedList.length,
            itemBuilder: (context, index) {
              final task = completedList[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text('${task.date} - ${task.time}'),
                onTap: () => showTaskDetails(task), // Show task details on tap
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => navigateToAddTaskScreen(task: task),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteTask(task.id!),
                    ),
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? value) {
                        if (value != null) {
                          updateTaskStatus(task, value);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}