import 'package:drift/drift.dart';
import '../database/app_database.dart';

class TodoRepository {
  final AppDatabase _database;

  TodoRepository(this._database);

  // Get all todos
  Stream<List<Todo>> watchAllTodos() {
    return _database.select(_database.todos).watch();
  }

  // Get completed todos
  Stream<List<Todo>> watchCompletedTodos() {
    return (_database.select(_database.todos)
      ..where((tbl) => tbl.done.equals(true))).watch();
  }

  // Get pending todos
  Stream<List<Todo>> watchPendingTodos() {
    return (_database.select(_database.todos)
      ..where((tbl) => tbl.done.equals(false))).watch();
  }

  // Add a new todo
  Future<int> addTodo(String title, {DateTime? dueDate}) async {
    return await _database
        .into(_database.todos)
        .insert(TodosCompanion.insert(title: title, dueDate: Value(dueDate)));
  }

  // Update todo status
  Future<bool> updateTodoStatus(Todo todo, bool isDone) async {
    return await _database
        .update(_database.todos)
        .replace(todo.copyWith(done: isDone));
  }

  // Update todo
  Future<bool> updateTodo(Todo todo, {String? title, DateTime? dueDate}) async {
    return await _database
        .update(_database.todos)
        .replace(
          todo.copyWith(title: title ?? todo.title, dueDate: Value(dueDate)),
        );
  }

  // Delete todo
  Future<int> deleteTodo(int id) async {
    return await (_database.delete(_database.todos)
      ..where((tbl) => tbl.id.equals(id))).go();
  }
}
