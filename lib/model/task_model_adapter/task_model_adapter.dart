import 'package:hive/hive.dart';

part 'task_model_adapter.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String note;

  @HiveField(3)
  String time;

  @HiveField(4)
  String date;

  @HiveField(5)
  bool isCompleted;

  TaskModel({
    this.id,
    required this.title,
    required this.note,
    required this.time,
    required this.date,
    required this.isCompleted,
  });
}