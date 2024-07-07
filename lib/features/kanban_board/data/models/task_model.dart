import 'package:hive/hive.dart';
import 'package:task_flow/core/constants/key_constants.dart';
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
  final DateTime? due;
  
  @HiveField(4)
  final String sectionId;
  
  @HiveField(5)
  final List<String> comments;
  
  @HiveField(6)
  final int duration;
  
  @HiveField(7)
  final DateTime? completedAt;

  const TaskModel({
    required this.id,
    this.isCompleted,
    required this.content,
    this.due,
    required this.sectionId,
    required this.comments,
    required this.duration,
    this.completedAt,
  }) : super(
          id: id,
          isCompleted: isCompleted,
          content: content,
          due: due,
          sectionId: sectionId,
          comments: comments,
          duration: duration,
          completedAt: completedAt,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json, {
    String? sectionId,
    List<String>? comments,
    int? duration,
    DateTime? dueDate,
    DateTime? completedAt,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: json['id'],
      content: json['content'] ?? "",
      due: dueDate,
      sectionId: sectionId ?? KeyConstants.todoSectionId,
      comments: comments ?? [],
      duration: duration ?? 0,
      isCompleted: isCompleted,
      completedAt: completedAt,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'is_completed': isCompleted,
  //     'content': content,
  //     'due': due?.toIso8601String(),
  //     'section_id': sectionId,
  //     'comments': comments,
  //     'duration': duration,
  //     'completed_at': completedAt?.toIso8601String(),
  //   };
  // }

  Map<String, dynamic> toJsonRemote() {
    return {
      'id': id,
      'content': content,
    };
  }
}