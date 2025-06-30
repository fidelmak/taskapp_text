import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:taskapp/using_shared/controller/todo_control.dart';
import 'package:taskapp/using_shared/views/todo_.dart';
import 'package:taskapp/utils/color_theme.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite for desktop platforms ONLY
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory for desktop platforms
    databaseFactory = databaseFactoryFfi;
  }
  // For Android and iOS, use the default sqflite implementation
  // No additional setup needed

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController =
        TodoController(); // Fixed typo: todoCOntroller -> todoController

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => todoController)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        themeMode: ThemeMode.system,
        theme: TaskAppColorTheme().buildLightTheme(),
        darkTheme: TaskAppColorTheme().buildDarkTheme(),
        home: const ScreenTodo(),
      ),
    );
  }
}
