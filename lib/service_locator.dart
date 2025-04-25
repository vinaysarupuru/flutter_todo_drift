import 'package:get_it/get_it.dart';

import 'database/app_database.dart';
import 'repository/todo_repository.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Register the database as a singleton
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Register the repository
  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepository(getIt<AppDatabase>()),
  );
}
