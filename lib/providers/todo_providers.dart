import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../repository/todo_repository.dart';
import '../service_locator.dart';

// Provider for the TodoRepository
final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => getIt<TodoRepository>(),
);

// Enum to define the filter states
enum TodoFilter { all, pending, completed }

// Provider for the current filter state
final todoFilterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

// Provider for filtered todos based on the selected filter
final filteredTodosProvider = StreamProvider<List<Todo>>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  final filter = ref.watch(todoFilterProvider);

  switch (filter) {
    case TodoFilter.all:
      return repository.watchAllTodos();
    case TodoFilter.pending:
      return repository.watchPendingTodos();
    case TodoFilter.completed:
      return repository.watchCompletedTodos();
  }
});
