// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoutineItemAdapter extends TypeAdapter<RoutineItem> {
  @override
  final int typeId = 0;

  @override
  RoutineItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutineItem(
      id: fields[0] as String?,
      title: fields[1] as String,
      description: fields[2] as String?,
      time: fields[3] as DateTime,
      enabled: fields[4] as bool,
      recurrence: fields[5] as Recurrence,
      weekdays: (fields[6] as List?)?.cast<int>(),
      reminderMinutesBefore: fields[7] as int,
    )..updatedAt = fields[9] as DateTime;
  }

  @override
  void write(BinaryWriter writer, RoutineItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.enabled)
      ..writeByte(5)
      ..write(obj.recurrence)
      ..writeByte(6)
      ..write(obj.weekdays)
      ..writeByte(7)
      ..write(obj.reminderMinutesBefore)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurrenceAdapter extends TypeAdapter<Recurrence> {
  @override
  final int typeId = 1;

  @override
  Recurrence read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Recurrence.none;
      case 1:
        return Recurrence.daily;
      case 2:
        return Recurrence.weekly;
      case 3:
        return Recurrence.custom;
      default:
        return Recurrence.none;
    }
  }

  @override
  void write(BinaryWriter writer, Recurrence obj) {
    switch (obj) {
      case Recurrence.none:
        writer.writeByte(0);
        break;
      case Recurrence.daily:
        writer.writeByte(1);
        break;
      case Recurrence.weekly:
        writer.writeByte(2);
        break;
      case Recurrence.custom:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
