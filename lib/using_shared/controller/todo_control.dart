import 'dart:convert';

import 'package:flutter/material.dart'; // Ensure this import is present for ThemeMode

import 'package:provider/provider.dart';
import 'package:taskapp/using_shared/model/todo_model.dart';
import 'package:taskapp/using_shared/service/todo_database_service.dart';

class TodoController with ChangeNotifier {
  final TodoDatabaseService _databaseService = TodoDatabaseService.instance;
  List<TodoModel>? _todoList = [];

  get todoList => _todoList;
  // SharedPreferences? get prefs => _prefs;

  // Example method to add a todo item
  void addTodo(todo) async {
    _todoList?.add(todo);

    notifyListeners();
  }

  Future<void> addTodoNow(TodoModel todo) async {
    try {
      await _databaseService.createTodo(todo);

      _todoList?.add(todo);

      notifyListeners();
    } catch (e) {}
  }

  void getTodos() async {
    try {
      final todos = await _databaseService.readAllTodos();

      _todoList = todos;

      notifyListeners();
    } catch (e) {}
    notifyListeners();
  }

  Future<void> deleteTodo(id) async {
    try {
      await _databaseService.deleteTodo(id);

      _todoList?.removeWhere((todo) => todo.id == id);

      notifyListeners();
    } catch (e) {}
  }

  Future<void> updateTodo(TodoModel todo) async {
    try {
      await _databaseService.updateTodo(todo);

      final index = _todoList?.indexWhere((t) => t.id == todo.id);
      if (index != null && index >= 0) {
        _todoList?[index] = todo;
      }

      notifyListeners();
    } catch (e) {}
  }

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  bool isDarkMode = false; // Tracks the current theme

  void toggleTheme() {
    isDarkMode = !isDarkMode; // Toggle between light and dark
    notifyListeners();
  }
}
