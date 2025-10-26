import 'package:flutter_test/flutter_test.dart';
import 'package:daily_flow/models/routine_item.dart';
import 'package:daily_flow/services/storage_service.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<RoutineItem> {}

void main() {
  group('StorageService', () {
    late StorageService storageService;
    late Box<RoutineItem> mockBox;

    setUp(() {
      mockBox = MockBox();
      storageService = StorageService();
      // Access the private field using a setter
      // Access the private field using dart:mirrors (not recommended for production)
      final field = storageService;
      (field as dynamic)._box = mockBox;
    });

    test('getAllRoutines should return list of routines', () {
      final routines = [
        RoutineItem(title: 'Test 1', time: DateTime.now()),
        RoutineItem(title: 'Test 2', time: DateTime.now()),
      ];

      when(() => mockBox.values).thenReturn(routines);

      final result = storageService.getAllRoutines();
      expect(result, equals(routines));
      verify(() => mockBox.values).called(1);
    });

    test('getRoutine should return a routine by id', () {
      final routine = RoutineItem(
        id: 'test-id',
        title: 'Test',
        time: DateTime.now(),
      );

      when(() => mockBox.get('test-id')).thenReturn(routine);

      final result = storageService.getRoutine('test-id');
      expect(result, equals(routine));
      verify(() => mockBox.get('test-id')).called(1);
    });

    test('addRoutine should put routine in box', () async {
      final routine = RoutineItem(
        title: 'Test',
        time: DateTime.now(),
      );

      when(() => mockBox.put(routine.id, routine))
          .thenAnswer((_) async => {});

      await storageService.addRoutine(routine);
      verify(() => mockBox.put(routine.id, routine)).called(1);
    });

    test('updateRoutine should update existing routine', () async {
      final routine = RoutineItem(
        title: 'Test',
        time: DateTime.now(),
      );

      when(() => mockBox.put(routine.id, routine))
          .thenAnswer((_) async => {});

      await storageService.updateRoutine(routine);
      verify(() => mockBox.put(routine.id, routine)).called(1);
    });

    test('deleteRoutine should remove routine from box', () async {
      const id = 'test-id';

      when(() => mockBox.delete(id)).thenAnswer((_) async => {});

      await storageService.deleteRoutine(id);
      verify(() => mockBox.delete(id)).called(1);
    });
  });
}