import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:daily_flow/models/routine_item.dart';
import 'package:daily_flow/services/notification_service.dart';
import 'package:daily_flow/services/storage_service.dart';

class ScheduleService {
  static final ScheduleService _instance = ScheduleService._internal();
  factory ScheduleService() => _instance;
  ScheduleService._internal();

  final NotificationService _notificationService = NotificationService();
  final StorageService _storageService = StorageService();
  static const int _rescheduleAlarmId = 999;

  Future<void> init() async {
    await AndroidAlarmManager.initialize();
    
    // Schedule a periodic task to check and reschedule notifications
    await AndroidAlarmManager.periodic(
      const Duration(hours: 12),
      _rescheduleAlarmId,
      _rescheduleRoutines,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  Future<void> scheduleRoutine(RoutineItem routine) async {
    if (!routine.enabled) return;
    await _notificationService.scheduleRoutineNotification(routine);
  }

  Future<void> cancelRoutine(String routineId) async {
    await _notificationService.cancelNotification(routineId);
  }

  @pragma('vm:entry-point')
  static Future<void> _rescheduleRoutines() async {
    final service = ScheduleService();
    await service._rescheduleAllRoutines();
  }

  Future<void> _rescheduleAllRoutines() async {
    final routines = _storageService.getAllRoutines();
    for (final routine in routines) {
      if (routine.enabled) {
        await scheduleRoutine(routine);
      }
    }
  }

  Future<void> rescheduleRoutinesAfterBoot() async {
    await _rescheduleAllRoutines();
  }

  DateTime getNextOccurrence(RoutineItem routine) {
    final now = DateTime.now();
    final routineTime = routine.time;
    
    switch (routine.recurrence) {
      case Recurrence.none:
        return routineTime;
        
      case Recurrence.daily:
        final nextTime = DateTime(
          now.year,
          now.month,
          now.day,
          routineTime.hour,
          routineTime.minute,
        );
        return nextTime.isBefore(now) 
            ? nextTime.add(const Duration(days: 1))
            : nextTime;
            
      case Recurrence.weekly:
        if (routine.weekdays == null || routine.weekdays!.isEmpty) {
          return routineTime;
        }
        
        var nextDate = DateTime(
          now.year,
          now.month,
          now.day,
          routineTime.hour,
          routineTime.minute,
        );
        
        while (!routine.weekdays!.contains(nextDate.weekday)) {
          nextDate = nextDate.add(const Duration(days: 1));
        }
        
        return nextDate.isBefore(now)
            ? nextDate.add(const Duration(days: 7))
            : nextDate;
            
      case Recurrence.custom:
        // Custom recurrence logic can be implemented here
        return routineTime;
    }
  }
}