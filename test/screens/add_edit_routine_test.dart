import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_flow/screens/add_edit_routine.dart';
import 'package:daily_flow/models/routine_item.dart';
import 'package:daily_flow/providers/routine_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<RoutineNotifier>()])
import 'add_edit_routine_test.mocks.dart';

void main() {
  group('AddEditRoutineScreen', () {
    late MockRoutineNotifier mockRoutineNotifier;

    setUp(() {
      mockRoutineNotifier = MockRoutineNotifier();
    });

    testWidgets('renders add routine form correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routineProvider.notifier.overrideWith((_) => mockRoutineNotifier),
          ],
          child: const MaterialApp(
            home: AddEditRoutineScreen(),
          ),
        ),
      );

      expect(find.text('Add Routine'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(DropdownButton<Recurrence>), findsOneWidget);
      expect(find.byType(SwitchListTile), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('can input routine details', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routineProvider.notifier.overrideWith((_) => mockRoutineNotifier),
          ],
          child: const MaterialApp(
            home: AddEditRoutineScreen(),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'Title'),
        'Test Routine',
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'Description (optional)'),
        'Test Description',
      );

      await tester.tap(find.text('One-time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Daily').last);
      await tester.pumpAndSettle();

      expect(find.text('Test Routine'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Daily'), findsWidgets);
    });

    testWidgets('shows validation error when title is empty', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routineProvider.notifier.overrideWith((_) => mockRoutineNotifier),
          ],
          child: const MaterialApp(
            home: AddEditRoutineScreen(),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a title'), findsOneWidget);
    });

    testWidgets('can save routine with valid data', (tester) async {
      when(mockRoutineNotifier.addRoutine(any))
          .thenAnswer((_) => Future.value());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routineProvider.notifier.overrideWith((_) => mockRoutineNotifier),
          ],
          child: const MaterialApp(
            home: AddEditRoutineScreen(),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'Title'),
        'Test Routine',
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      verify(mockRoutineNotifier.addRoutine(any)).called(1);
    });
  });
}