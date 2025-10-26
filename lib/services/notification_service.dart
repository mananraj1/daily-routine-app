import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:daily_flow/models/routine_item.dart';

// Background callback must be a top-level or static function and annotated as an
// entry-point so the native side can invoke it when app is in background.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  // You can perform lightweight background handling here. Keep it minimal.
  // For now we just log or ignore — heavier work should be deferred to
  // a background isolate or handled when the app is resumed.
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Initialize notification settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Request notification permissions
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request permissions for Android 13 and above
    await _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  Future<void> scheduleRoutineNotification(RoutineItem routine) async {
    if (!routine.enabled) return;

    final notificationTime = tz.TZDateTime.from(
      routine.time.subtract(Duration(minutes: routine.reminderMinutesBefore)),
      tz.local,
    );

    // Cancel any existing notification for this routine
    await cancelNotification(routine.id);

    // Create notification details with actions
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'routine_notifications',
        'Routine Notifications',
        channelDescription: 'Notifications for daily routines',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        actions: [
          const AndroidNotificationAction('snooze', 'Snooze 5m'),
          const AndroidNotificationAction('mark_done', 'Mark Done'),
        ],
      ),
    );

    await _notificationsPlugin.zonedSchedule(
      routine.id.hashCode,
      routine.title,
      routine.description ?? 'Time for your routine!',
      notificationTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: _getMatchDateTimeComponents(routine.recurrence),
      payload: routine.id,
    );
  }

  DateTimeComponents? _getMatchDateTimeComponents(Recurrence recurrence) {
    switch (recurrence) {
      case Recurrence.daily:
        return DateTimeComponents.time;
      case Recurrence.weekly:
        return DateTimeComponents.dayOfWeekAndTime;
      case Recurrence.custom:
      case Recurrence.none:
        return null;
    }
  }

  Future<void> cancelNotification(String routineId) async {
    await _notificationsPlugin.cancel(routineId.hashCode);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    if (response.payload != null) {
      final routineId = response.payload!;

      // Handle actions
      switch (response.actionId) {
        case 'snooze':
          _handleSnoozeAction(routineId);
          break;
        case 'mark_done':
          _handleMarkDoneAction(routineId);
          break;
        default:
        // Regular notification tap - navigate to routine details
        // This will be implemented later with navigation
          break;
      }
    }
  }

  Future<void> _handleSnoozeAction(String routineId) async {
    // Schedule a new notification 5 minutes from now
    final snoozeTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 5));

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'routine_notifications',
        'Routine Notifications',
        channelDescription: 'Notifications for daily routines',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      ),
    );

    await _notificationsPlugin.zonedSchedule(
      routineId.hashCode,
      'Snoozed Routine',
      'Reminder: Complete your routine',
      snoozeTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: routineId,
    );
  }

  void _handleMarkDoneAction(String routineId) {
    // This will be implemented later with state management
    // to mark the routine as completed
  }
}