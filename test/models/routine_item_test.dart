import 'package:flutter_test/flutter_test.dart';
import 'package:daily_flow/models/routine_item.dart';

void main() {
  group('RoutineItem', () {
    test('should create a RoutineItem with required fields', () {
      final now = DateTime.now();
      final routine = RoutineItem(
        title: 'Test Routine',
        time: now,
      );

      expect(routine.title, equals('Test Routine'));
      expect(routine.time, equals(now));
      expect(routine.enabled, isTrue);
      expect(routine.recurrence, equals(Recurrence.none));
      expect(routine.reminderMinutesBefore, equals(0));
      expect(routine.id, isNotEmpty);
      expect(routine.weekdays, isNull);
      expect(routine.description, isNull);
    });

    test('should create a RoutineItem with all fields', () {
      final now = DateTime.now();
      final routine = RoutineItem(
        id: 'test-id',
        title: 'Test Routine',
        description: 'Test Description',
        time: now,
        enabled: false,
        recurrence: Recurrence.weekly,
        weekdays: [1, 3, 5],
        reminderMinutesBefore: 15,
      );

      expect(routine.id, equals('test-id'));
      expect(routine.title, equals('Test Routine'));
      expect(routine.description, equals('Test Description'));
      expect(routine.time, equals(now));
      expect(routine.enabled, isFalse);
      expect(routine.recurrence, equals(Recurrence.weekly));
      expect(routine.weekdays, equals([1, 3, 5]));
      expect(routine.reminderMinutesBefore, equals(15));
    });

    test('copyWith should create a new instance with updated fields', () {
      final now = DateTime.now();
      final routine = RoutineItem(
        title: 'Test Routine',
        time: now,
      );

      final updated = routine.copyWith(
        title: 'Updated Title',
        description: 'New Description',
        enabled: false,
      );

      expect(updated.id, equals(routine.id));
      expect(updated.title, equals('Updated Title'));
      expect(updated.description, equals('New Description'));
      expect(updated.time, equals(now));
      expect(updated.enabled, isFalse);
      expect(updated.recurrence, equals(Recurrence.none));
      expect(updated.reminderMinutesBefore, equals(0));
    });
  });
}