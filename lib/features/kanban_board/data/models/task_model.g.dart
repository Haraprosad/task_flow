// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      id: fields[0] as String,
      isCompleted: fields[1] as bool?,
      content: fields[2] as String,
      due: fields[3] as Due?,
      sectionId: fields[4] as String,
      comments: (fields[5] as List).cast<String>(),
      duration: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.due)
      ..writeByte(4)
      ..write(obj.sectionId)
      ..writeByte(5)
      ..write(obj.comments)
      ..writeByte(6)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DueModelAdapter extends TypeAdapter<DueModel> {
  @override
  final int typeId = 1;

  @override
  DueModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DueModel(
      date: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DueModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DueModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
