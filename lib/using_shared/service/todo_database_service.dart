// import 'package:path/path.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:taskapp/using_shared/model/todo_model.dart';

// class TodoDatabaseService {
//   static const String _databaseName = 'todos.db';
//   static const int _databaseVersion = 1;

//   // Singleton pattern
//   static final TodoDatabaseService instance = TodoDatabaseService._internal();
//   TodoDatabaseService._internal();
//   factory TodoDatabaseService() => instance;

//   Database? _database;
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     final path = join(await getDatabasesPath(), _databaseName);
//     return await openDatabase(
//       path,
//       version: _databaseVersion,
//       onCreate: _onCreate,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE todos (
//         id TEXT PRIMARY KEY,
//         title TEXT NOT NULL,
//         description TEXT NOT NULL,
//         dateTime TEXT NOT NULL,
//         isCompleted INTEGER NOT NULL DEFAULT 0
//       )
//     ''');
//   }

//   // CRUD Operations

//   Future<int> createTodo(TodoModel todo) async {
//     final db = await database;
//     // Convert TodoModel to Map for database insertion
//     final todoMap = {
//       'id': todo.id,
//       'title': todo.title,
//       'description': todo.description,
//       'dateTime': todo.dateTime.toIso8601String(), // Ensure proper date format
//       'isCompleted': todo.isCompleted ? 1 : 0, // Convert bool to int
//     };
//     return await db.insert('todos', todoMap);
//   }

//   Future<List<TodoModel>> readAllTodos() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('todos');
//     return maps.map((map) => _mapToTodoModel(map)).toList();
//   }

//   Future<List<TodoModel>> readCompletedTodos() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query(
//       'todos',
//       where: 'isCompleted = ?',
//       whereArgs: [1],
//     );
//     return maps.map((map) => _mapToTodoModel(map)).toList();
//   }

//   Future<List<TodoModel>> readPendingTodos() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query(
//       'todos',
//       where: 'isCompleted = ?',
//       whereArgs: [0],
//     );
//     return maps.map((map) => _mapToTodoModel(map)).toList();
//   }

//   Future<int> updateTodo(TodoModel todo) async {
//     final db = await database;
//     final todoMap = {
//       'id': todo.id,
//       'title': todo.title,
//       'description': todo.description,
//       'dateTime': todo.dateTime.toIso8601String(),
//       'isCompleted': todo.isCompleted ? 1 : 0,
//     };
//     return await db.update(
//       'todos',
//       todoMap,
//       where: 'id = ?',
//       whereArgs: [todo.id],
//     );
//   }

//   Future<int> deleteTodo(String id) async {
//     final db = await database;
//     return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<void> deleteAllTodos() async {
//     final db = await database;
//     await db.delete('todos');
//   }

//   Future<void> close() async {
//     final db = _database;
//     if (db != null) {
//       await db.close();
//       _database = null;
//     }
//   }

//   // Helper method to convert database map to TodoModel
//   TodoModel _mapToTodoModel(Map<String, dynamic> map) {
//     return TodoModel(
//       id: map['id'] as String,
//       title: map['title'] as String,
//       description: map['description'] as String,
//       dateTime: DateTime.parse(map['dateTime'] as String),
//       isCompleted: (map['isCompleted'] as int) == 1,
//     );
//   }
// }

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; // Changed from sqflite_common_ffi
import 'package:taskapp/using_shared/model/todo_model.dart';

class TodoDatabaseService {
  static const String _databaseName = 'todos.db';
  static const int _databaseVersion = 1;

  // Singleton pattern
  static final TodoDatabaseService instance = TodoDatabaseService._internal();
  TodoDatabaseService._internal();
  factory TodoDatabaseService() => instance;

  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // CRUD Operations

  Future<int> createTodo(TodoModel todo) async {
    final db = await database;
    // Convert TodoModel to Map for database insertion
    final todoMap = {
      'id': todo.id,
      'title': todo.title,
      'description': todo.description,
      'dateTime': todo.dateTime.toIso8601String(), // Ensure proper date format
      'isCompleted': todo.isCompleted ? 1 : 0, // Convert bool to int
    };
    return await db.insert('todos', todoMap);
  }

  Future<List<TodoModel>> readAllTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return maps.map((map) => _mapToTodoModel(map)).toList();
  }

  Future<List<TodoModel>> readCompletedTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );
    return maps.map((map) => _mapToTodoModel(map)).toList();
  }

  Future<List<TodoModel>> readPendingTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'isCompleted = ?',
      whereArgs: [0],
    );
    return maps.map((map) => _mapToTodoModel(map)).toList();
  }

  Future<int> updateTodo(TodoModel todo) async {
    final db = await database;
    final todoMap = {
      'id': todo.id,
      'title': todo.title,
      'description': todo.description,
      'dateTime': todo.dateTime.toIso8601String(),
      'isCompleted': todo.isCompleted ? 1 : 0,
    };
    return await db.update(
      'todos',
      todoMap,
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodo(String id) async {
    final db = await database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllTodos() async {
    final db = await database;
    await db.delete('todos');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // Helper method to convert database map to TodoModel
  TodoModel _mapToTodoModel(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      isCompleted: (map['isCompleted'] as int) == 1,
    );
  }
}
