import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/using_shared/controller/todo_control.dart';
import 'package:taskapp/using_shared/model/todo_model.dart';

enum FilterType { all, completed, pending }

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  bool isCompleted = false;
  bool isSearching = false;
  FilterType currentFilter = FilterType.all;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoController>().getTodos();
    });

    // Listen to search input changes
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  void updateTodo(TodoModel existingTodo, String title, String description) {
    // Create updated todo with the same ID and date
    final updatedTodo = TodoModel(
      id: existingTodo.id, // Keep the same ID for updates
      title: title,
      description: description,
      dateTime: existingTodo.dateTime, // Keep original date
      isCompleted: existingTodo.isCompleted, // Keep current completion status
    );

    Provider.of<TodoController>(context, listen: false).updateTodo(updatedTodo);
  }

  void toggleTodoCompletion(TodoModel todo) {
    final updatedTodo = TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      dateTime: todo.dateTime,
      isCompleted: !todo.isCompleted, // Toggle completion status
    );

    Provider.of<TodoController>(context, listen: false).updateTodo(updatedTodo);
  }

  List<TodoModel> getFilteredTodos(List<TodoModel> todos) {
    List<TodoModel> filteredTodos = todos;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filteredTodos =
          filteredTodos.where((todo) {
            return todo.title.toLowerCase().contains(searchQuery) ||
                todo.description.toLowerCase().contains(searchQuery);
          }).toList();
    }

    // Apply completion status filter
    switch (currentFilter) {
      case FilterType.completed:
        filteredTodos =
            filteredTodos.where((todo) => todo.isCompleted).toList();
        break;
      case FilterType.pending:
        filteredTodos =
            filteredTodos.where((todo) => !todo.isCompleted).toList();
        break;
      case FilterType.all:
      default:
        // No additional filtering needed
        break;
    }

    return filteredTodos;
  }

  void _clearSearch() {
    searchController.clear();
    setState(() {
      searchQuery = '';
      isSearching = false;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        title:
            isSearching
                ? TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).appBarTheme.foregroundColor?.withOpacity(0.6),
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                  autofocus: true,
                )
                : const Text("All Tasks"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          if (isSearching)
            IconButton(icon: const Icon(Icons.clear), onPressed: _clearSearch)
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            ),
          PopupMenuButton<FilterType>(
            icon: const Icon(Icons.filter_list),
            onSelected: (FilterType filter) {
              setState(() {
                currentFilter = filter;
              });
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem(
                    value: FilterType.all,
                    child: Row(
                      children: [
                        Icon(
                          Icons.list,
                          color:
                              currentFilter == FilterType.all
                                  ? Theme.of(context).primaryColor
                                  : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'All Tasks',
                          style: TextStyle(
                            color:
                                currentFilter == FilterType.all
                                    ? Theme.of(context).primaryColor
                                    : null,
                            fontWeight:
                                currentFilter == FilterType.all
                                    ? FontWeight.bold
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: FilterType.pending,
                    child: Row(
                      children: [
                        Icon(
                          Icons.pending_actions,
                          color:
                              currentFilter == FilterType.pending
                                  ? Theme.of(context).primaryColor
                                  : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pending',
                          style: TextStyle(
                            color:
                                currentFilter == FilterType.pending
                                    ? Theme.of(context).primaryColor
                                    : null,
                            fontWeight:
                                currentFilter == FilterType.pending
                                    ? FontWeight.bold
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: FilterType.completed,
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color:
                              currentFilter == FilterType.completed
                                  ? Theme.of(context).primaryColor
                                  : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Completed',
                          style: TextStyle(
                            color:
                                currentFilter == FilterType.completed
                                    ? Theme.of(context).primaryColor
                                    : null,
                            fontWeight:
                                currentFilter == FilterType.completed
                                    ? FontWeight.bold
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
          ),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              final themeMode =
                  Theme.of(context).brightness == Brightness.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
              context.read<TodoController>().setThemeMode(themeMode);
            },
          ),
        ],
      ),
      body: Consumer<TodoController>(
        builder: (context, todoController, child) {
          final todoList = todoController.todoList;

          if (todoList == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (todoList.isEmpty) {
            return const Center(
              child: Text("No tasks available", style: TextStyle(fontSize: 18)),
            );
          }

          final filteredTodos = getFilteredTodos(todoList);

          // Show filter/search results info
          return Column(
            children: [
              if (searchQuery.isNotEmpty || currentFilter != FilterType.all)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getFilterInfoText(
                            filteredTodos.length,
                            todoList.length,
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      if (searchQuery.isNotEmpty ||
                          currentFilter != FilterType.all)
                        TextButton(
                          onPressed: () {
                            _clearSearch();
                            setState(() {
                              currentFilter = FilterType.all;
                            });
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              Expanded(
                child:
                    filteredTodos.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _getEmptyStateText(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: filteredTodos.length,
                          itemBuilder: (context, index) {
                            final todo = filteredTodos[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Dismissible(
                                key: Key(todo.id.toString()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20.0),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  context.read<TodoController>().deleteTodo(
                                    todo.id,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Task '${todo.title}' deleted successfully",
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      DateFormat(
                                        'MMM\ndd',
                                      ).format(todo.dateTime),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    todo.title,
                                    style: TextStyle(
                                      decoration:
                                          todo.isCompleted
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                      color:
                                          todo.isCompleted ? Colors.grey : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    todo.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color:
                                          todo.isCompleted ? Colors.grey : null,
                                    ),
                                  ),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed:
                                              () => _showEditDialog(
                                                context,
                                                todo,
                                              ),
                                        ),
                                        Checkbox(
                                          value: todo.isCompleted,
                                          onChanged: (value) {
                                            toggleTodoCompletion(todo);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getFilterInfoText(int filteredCount, int totalCount) {
    String filterText = '';

    if (searchQuery.isNotEmpty) {
      filterText += 'Search: "$searchQuery"';
    }

    if (currentFilter != FilterType.all) {
      if (filterText.isNotEmpty) filterText += ' • ';
      filterText += 'Filter: ${currentFilter.name.toUpperCase()}';
    }

    return '$filterText • Showing $filteredCount of $totalCount tasks';
  }

  String _getEmptyStateText() {
    if (searchQuery.isNotEmpty && currentFilter != FilterType.all) {
      return 'No ${currentFilter.name} tasks found\nmatching "$searchQuery"';
    } else if (searchQuery.isNotEmpty) {
      return 'No tasks found matching\n"$searchQuery"';
    } else if (currentFilter != FilterType.all) {
      return 'No ${currentFilter.name} tasks found';
    }
    return 'No tasks available';
  }

  void _showEditDialog(BuildContext context, TodoModel todo) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  updateTodo(
                    todo,
                    titleController.text.trim(),
                    descriptionController.text.trim(),
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Task updated successfully"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    ).then((_) {
      // Dispose controllers when dialog closes
      titleController.dispose();
      descriptionController.dispose();
    });
  }
}
