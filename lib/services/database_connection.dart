import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/task_model.dart';

class DatabaseRepo {
  static Database? _dbService;

  // Create the database
  static Future<void> createDB() async {
    if (_dbService != null) return; // Database is already initialized

    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'task.db');

      _dbService = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE tasks ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'title TEXT NOT NULL, '
                'note TEXT NOT NULL, '
                'time TEXT NOT NULL, '
                'date TEXT NOT NULL, '
                'isCompleted INTEGER NOT NULL)',
          );
        },
      );
    } catch (e) {
      throw Exception('Database initialization failed: $e');
    }
  }

  // Get the database instance
  static Database get dbService {
    if (_dbService == null) {
      throw Exception("Database is not initialized. Call createDB() first.");
    }
    return _dbService!;
  }

  // Insert record
  static Future<int> insertRecord(TaskModel task) async {
    final db = dbService;
    return await db.insert(
      'tasks',
      {
        'title': task.title,
        'note': task.note,
        'time': task.time,
        'date': task.date,
        'isCompleted': task.isCompleted ? 1 : 0,
      },
    );
  }

  // Fetch records
  static Future<List<TaskModel>> getRecords() async {
    final db = dbService;
    final List<Map<String, dynamic>> result = await db.query('tasks');
    return result.map((row) {
      return TaskModel(
        id: row['id'] as int?,
        title: row['title'] as String,
        note: row['note'] as String,
        time: row['time'] as String,
        date: row['date'] as String,
        isCompleted: (row['isCompleted'] as int) == 1,
      );
    }).toList();
  }

  // Update record
  static Future<int> updateRecord(TaskModel task) async {
    final db = dbService;
    return await db.update(
      'tasks',
      {
        'title': task.title,
        'note': task.note,
        'time': task.time,
        'date': task.date,
        'isCompleted': task.isCompleted ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete record
  static Future<int> deleteRecord(int id) async {
    final db = dbService;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get task by ID
  static Future<TaskModel?> getTaskById(int id) async {
    final db = dbService;
    final List<Map<String, dynamic>> result =
    await db.query('tasks', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      final row = result.first;
      return TaskModel(
        id: row['id'] as int?,
        title: row['title'] as String,
        note: row['note'] as String,
        time: row['time'] as String,
        date: row['date'] as String,
        isCompleted: (row['isCompleted'] as int) == 1,
      );
    }
    return null;
  }
}