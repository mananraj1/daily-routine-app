import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_flow/screens/home_screen.dart';
import 'package:daily_flow/utils/app_theme.dart';
import 'package:daily_flow/screens/settings_screen.dart';
import 'package:daily_flow/services/storage_service.dart';
import 'package:daily_flow/services/notification_service.dart';
import 'package:daily_flow/services/schedule_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final storageService = StorageService();
  await storageService.init();

  final notificationService = NotificationService();
  await notificationService.init();

  final scheduleService = ScheduleService();
  await scheduleService.init();

  runApp(
    const ProviderScope(
      child: DailyFlowApp(),
    ),
  );
}

class DailyFlowApp extends ConsumerWidget {
  const DailyFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'DailyFlow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
