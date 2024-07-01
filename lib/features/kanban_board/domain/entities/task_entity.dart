import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final bool? isCompleted;
  final String content;
  final DateTime? due;
  final DateTime? completedAt;
  final String sectionId;
  final List<String> comments;
  final int duration;

  const TaskEntity({
    required this.id,
    this.isCompleted,
    required this.content,
    this.due,
    this.completedAt,
    required this.sectionId,
    required this.comments,
    required this.duration,
  });

  TaskEntity copyWith({
    String? id,
    bool? isCompleted,
    String? content,
    DateTime? due,
    DateTime? completedAt,
    String? sectionId,
    List<String>? comments,
    int? duration,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      isCompleted: isCompleted ?? this.isCompleted,
      content: content ?? this.content,
      due: due ?? this.due,
      completedAt: completedAt ?? this.completedAt,
      sectionId: sectionId ?? this.sectionId,
      comments: comments ?? this.comments,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [
        id,
        isCompleted,
        content,
        due,
        completedAt,
        sectionId,
        comments,
        duration,
      ];
}
