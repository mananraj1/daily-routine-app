import 'package:hive_flutter/hive_flutter.dart';
import 'package:daily_flow/models/routine_item.dart';

class StorageService {
  static const String _boxName = 'routines';
  late Box<RoutineItem> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(RoutineItemAdapter());
    Hive.registerAdapter(RecurrenceAdapter());
    
    // Open the box
    _box = await Hive.openBox<RoutineItem>(_boxName);
  }

  Future<void> addRoutine(RoutineItem routine) async {
    await _box.put(routine.id, routine);
  }

  Future<void> updateRoutine(RoutineItem routine) async {
    routine.updatedAt = DateTime.now();
    await _box.put(routine.id, routine);
  }

  Future<void> deleteRoutine(String id) async {
    await _box.delete(id);
  }

  RoutineItem? getRoutine(String id) {
    return _box.get(id);
  }

  List<RoutineItem> getAllRoutines() {
    return _box.values.toList();
  }

  Future<void> clear() async {
    await _box.clear();
  }

  Stream<BoxEvent> get routineStream => _box.watch();
}