import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'routine_item.g.dart';

@HiveType(typeId: 0)
class RoutineItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime time;

  @HiveField(4)
  bool enabled;

  @HiveField(5)
  Recurrence recurrence;

  @HiveField(6)
  List<int>? weekdays;

  @HiveField(7)
  int reminderMinutesBefore;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  RoutineItem({
    String? id,
    required this.title,
    this.description,
    required this.time,
    this.enabled = true,
    this.recurrence = Recurrence.none,
    this.weekdays,
    this.reminderMinutesBefore = 0,
  })  : id = id ?? const Uuid().v4(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  RoutineItem copyWith({
    String? title,
    String? description,
    DateTime? time,
    bool? enabled,
    Recurrence? recurrence,
    List<int>? weekdays,
    int? reminderMinutesBefore,
  }) {
    return RoutineItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      enabled: enabled ?? this.enabled,
      recurrence: recurrence ?? this.recurrence,
      weekdays: weekdays ?? this.weekdays,
      reminderMinutesBefore: reminderMinutesBefore ?? this.reminderMinutesBefore,
    );
  }
}

@HiveType(typeId: 1)
enum Recurrence {
  @HiveField(0)
  none,
  @HiveField(1)
  daily,
  @HiveField(2)
  weekly,
  @HiveField(3)
  custom
}