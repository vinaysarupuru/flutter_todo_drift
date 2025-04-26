import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/home_page.dart';
import 'providers/theme_provider.dart';
import 'service_locator.dart';
import 'theme/app_theme.dart';

void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set up the dependency injection
  setupServiceLocator();

  // Run the app with ProviderScope for Riverpod
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for theme changes
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(),
    );
  }
}
