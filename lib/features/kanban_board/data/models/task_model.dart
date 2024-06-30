import 'package:task_flow/features/kanban_board/domain/entities/due.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.isCompleted,
    required super.content,
    required super.sectionId,
    super.due,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      isCompleted: json['is_completed'] ?? false,
      content: json['content'] ?? "",
      sectionId: json['section_id'] ?? "",
      due: json['due'] != null ? DueModel.fromJson(json['due']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_completed': isCompleted,
      'content': content,
      'section_id': sectionId,
      'due': due != null ? (due as DueModel).toJson() : null,
    };
  }
}

class DueModel extends Due {
  const DueModel({required super.date});

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
