import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/using_shared/controller/todo_control.dart';
import 'package:taskapp/using_shared/model/todo_model.dart';
import 'package:taskapp/using_shared/views/todo_screen.dart';

class ScreenTodo extends StatefulWidget {
  const ScreenTodo({super.key});

  @override
  State<ScreenTodo> createState() => _ScreenTodoState();
}

class _ScreenTodoState extends State<ScreenTodo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  bool isCompleted = false;
  bool isLoading = false;

  void addTodo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final todoController = Provider.of<TodoController>(
        context,
        listen: false,
      );

      await todoController.addTodoNow(
        TodoModel(
          id:
              DateTime.now().millisecondsSinceEpoch
                  .toString(), // More unique ID
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          dateTime: selectedDate ?? DateTime.now(),
          isCompleted: isCompleted,
        ),
      );

      // Clear the form after adding
      _clearForm();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task added successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding task: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    setState(() {
      selectedDate = null;
      isCompleted = false;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 1),
      ), // Can't select past dates
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 2),
      ), // 2 years from now
      helpText: 'Select deadline date',
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('New Task'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<TodoController>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task Details',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        // Title Field
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Task Title *',
                            hintText: 'Enter a descriptive title',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.title),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a task title';
                            }
                            if (value.trim().length < 3) {
                              return 'Title must be at least 3 characters long';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 16),

                        // Description Field
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'Add more details about the task',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.description),
                          ),
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Date and Status Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task Settings',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        // Date Picker
                        InkWell(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    selectedDate != null
                                        ? 'Deadline: ${DateFormat('MMM dd, yyyy').format(selectedDate!)}'
                                        : 'Select deadline date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          selectedDate != null
                                              ? Theme.of(
                                                context,
                                              ).textTheme.bodyLarge?.color
                                              : Colors.grey[600],
                                    ),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Completion Status
                        CheckboxListTile(
                          title: const Text('Mark as completed'),
                          subtitle: const Text(
                            'Check if this task is already done',
                          ),
                          value: isCompleted,
                          onChanged: (bool? value) {
                            setState(() {
                              isCompleted = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Container(
                  padding: EdgeInsets.only(left: 9, right: 9),
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : addTodo,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('Add Task'),
                  ),
                ),

                const SizedBox(height: 16),

                // View All Tasks Button
                Container(
                  padding: EdgeInsets.only(left: 9, right: 9),
                  height: MediaQuery.of(context).size.height * 0.10,

                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TodoScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.list),
                    label: const Text('View Tasks'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
