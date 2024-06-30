import 'package:hive/hive.dart';
import 'package:task_flow/features/kanban_board/domain/entities/due.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends TaskEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final bool? isCompleted;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final Due? due;
  @HiveField(4)
  final String sectionId;
  @HiveField(5)
  final List<String> comments;
  @HiveField(6)
  final int duration;

  const TaskModel({
    required this.id,
    this.isCompleted,
    required this.content,
    this.due,
    required this.sectionId,
    required this.comments,
    required this.duration,
  }) : super(
          id: id,
          isCompleted: isCompleted,
          content: content,
          due: due,
          sectionId: sectionId,
          comments: comments,
          duration: duration,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json, {String? sectionId, List<String>? comments, int? duration}) {
    return TaskModel(
      id: json['id'],
      isCompleted: json['is_completed'] ?? false,
      content: json['content'] ?? "",
      due: json['due'] != null ? DueModel.fromJson(json['due']) : null,
      sectionId: sectionId ?? 'todo',
      comments: comments ?? [],
      duration: duration ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_completed': isCompleted,
      'content': content,
      'due': due != null ? (due as DueModel).toJson() : null,
      'section_id': sectionId,
      'comments': comments,
      'duration': duration,
    };
  }

  Map<String, dynamic> toJsonRemote() {
    return {
      'id': id,
      'is_completed': isCompleted,
      'content': content,
      'due': due != null ? (due as DueModel).toJson() : null,
    };
  }
}

@HiveType(typeId: 1)
class DueModel extends Due {
  @HiveField(0)
  final String date;

  const DueModel({required this.date}) : super(date: date);

  factory DueModel.fromJson(Map<String, dynamic> json) {
    return DueModel(
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
    };
  }
}
