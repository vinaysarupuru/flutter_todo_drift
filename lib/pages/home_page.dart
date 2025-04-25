import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../providers/todo_providers.dart';
import '../repository/todo_repository.dart';
import '../service_locator.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Column(
        children: [
          // Filter tabs
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton(context, ref, TodoFilter.all),
                _buildFilterButton(context, ref, TodoFilter.pending),
                _buildFilterButton(context, ref, TodoFilter.completed),
              ],
            ),
          ),

          // Todo list
          Expanded(child: _buildTodoList(ref)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
    WidgetRef ref,
    TodoFilter filter,
  ) {
    final selectedFilter = ref.watch(todoFilterProvider);
    final isSelected = selectedFilter == filter;

    return ElevatedButton(
      onPressed: () => ref.read(todoFilterProvider.notifier).state = filter,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Theme.of(context).primaryColor : null,
        foregroundColor: isSelected ? Colors.white : null,
      ),
      child: Text(_getFilterName(filter)),
    );
  }

  String _getFilterName(TodoFilter filter) {
    switch (filter) {
      case TodoFilter.all:
        return 'All';
      case TodoFilter.pending:
        return 'Pending';
      case TodoFilter.completed:
        return 'Completed';
    }
  }

  Widget _buildTodoList(WidgetRef ref) {
    final todosAsyncValue = ref.watch(filteredTodosProvider);

    return todosAsyncValue.when(
      data: (todos) {
        if (todos.isEmpty) {
          return const Center(child: Text('No todos found'));
        }

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return _buildTodoItem(context, ref, todo);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildTodoItem(BuildContext context, WidgetRef ref, Todo todo) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Dismissible(
      key: Key(todo.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        final repository = getIt<TodoRepository>();
        repository.deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Todo deleted: ${todo.title}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: ListTile(
        leading: Checkbox(
          value: todo.done,
          onChanged: (value) {
            if (value != null) {
              final repository = getIt<TodoRepository>();
              repository.updateTodoStatus(todo, value);
            }
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle:
            todo.dueDate != null
                ? Text(
                  'Due: ${dateFormat.format(todo.dueDate!)}',
                  style: TextStyle(
                    color: _getDueDateColor(todo.dueDate!, todo.done),
                    decoration: todo.done ? TextDecoration.lineThrough : null,
                  ),
                )
                : null,
        onTap: () => _showEditTodoSheet(context, todo),
      ),
    );
  }

  Color _getDueDateColor(DateTime dueDate, bool done) {
    if (done) return Colors.grey;

    final today = DateTime.now();
    print('Today: $today');
    final difference = dueDate.difference(today).inDays;
    print('Due date: $dueDate, Difference: $difference');

    if (dueDate.isBefore(DateTime(today.year, today.month, today.day))) {
      return Colors.red; // Overdue
    } else if (difference <= 1) {
      return Colors.orange; // Due today or tomorrow
    } else {
      return Colors.green; // Due later
    }
  }

  void _showAddTodoSheet(BuildContext context) {
    _showTodoSheet(context, null);
  }

  void _showEditTodoSheet(BuildContext context, Todo todo) {
    _showTodoSheet(context, todo);
  }

  void _showTodoSheet(BuildContext context, Todo? todo) {
    final isEditing = todo != null;
    final textController = TextEditingController(
      text: isEditing ? todo.title : '',
    );
    DateTime? selectedDate = isEditing ? todo.dueDate : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? 'Edit Todo' : 'Add New Todo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: textController,
                    autofocus: !isEditing,
                    decoration: const InputDecoration(
                      labelText: 'Todo Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate != null
                              ? 'Due Date: ${DateFormat('MMM dd, yyyy').format(selectedDate!)}'
                              : 'No Due Date Set',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365 * 5),
                            ),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Text(
                          selectedDate == null
                              ? 'Set Due Date'
                              : 'Change Due Date',
                        ),
                      ),
                      if (selectedDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              selectedDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (textController.text.trim().isNotEmpty) {
                            final repository = getIt<TodoRepository>();

                            if (isEditing) {
                              repository.updateTodo(
                                todo,
                                title: textController.text.trim(),
                                dueDate: selectedDate,
                              );
                            } else {
                              repository.addTodo(
                                textController.text.trim(),
                                dueDate: selectedDate,
                              );
                            }

                            Navigator.pop(context);
                          }
                        },
                        child: Text(isEditing ? 'Update' : 'Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
