import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_flow/models/routine_item.dart';
import 'package:daily_flow/services/storage_service.dart';
import 'package:daily_flow/services/schedule_service.dart';

final routineProvider = StateNotifierProvider<RoutineNotifier, List<RoutineItem>>(
  (ref) => RoutineNotifier(),
);

class RoutineNotifier extends StateNotifier<List<RoutineItem>> {
  RoutineNotifier() : super([]) {
    _loadRoutines();
  }

  final StorageService _storageService = StorageService();
  final ScheduleService _scheduleService = ScheduleService();

  Future<void> _loadRoutines() async {
    state = _storageService.getAllRoutines();
  }

  Future<void> addRoutine(RoutineItem routine) async {
    await _storageService.addRoutine(routine);
    await _scheduleService.scheduleRoutine(routine);
    state = [...state, routine];
  }

  Future<void> updateRoutine(RoutineItem routine) async {
    await _storageService.updateRoutine(routine);
    await _scheduleService.scheduleRoutine(routine);
    state = [
      for (final item in state)
        if (item.id == routine.id) routine else item
    ];
  }

  Future<void> deleteRoutine(String id) async {
    await _storageService.deleteRoutine(id);
    await _scheduleService.cancelRoutine(id);
    state = state.where((item) => item.id != id).toList();
  }

  Future<void> toggleRoutine(String id) async {
    final routine = state.firstWhere((item) => item.id == id);
    final updatedRoutine = routine.copyWith(enabled: !routine.enabled);
    await updateRoutine(updatedRoutine);
  }

  List<RoutineItem> getTodayRoutines() {
    final now = DateTime.now();
    return state.where((routine) {
      final nextOccurrence = _scheduleService.getNextOccurrence(routine);
      return nextOccurrence.year == now.year &&
          nextOccurrence.month == now.month &&
          nextOccurrence.day == now.day;
    }).toList();
  }

  List<RoutineItem> getUpcomingRoutines() {
    final now = DateTime.now();
    return state.where((routine) {
      final nextOccurrence = _scheduleService.getNextOccurrence(routine);
      return nextOccurrence.isAfter(now);
    }).toList();
  }
}