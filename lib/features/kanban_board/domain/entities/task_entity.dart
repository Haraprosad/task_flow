import 'package:equatable/equatable.dart';
import 'due.dart';

class TaskEntity extends Equatable {
  final String id;
  final bool? isCompleted;
  final String content;
  final Due? due;
  final String? sectionId;

  const TaskEntity({
    required this.id,
    this.isCompleted,
    required this.content,
    this.due,
    this.sectionId,
  });

  TaskEntity copyWith({
    String? id,
    bool? isCompleted,
    String? content,
    Due? due,
    String? sectionId,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      isCompleted: isCompleted ?? this.isCompleted,
      content: content ?? this.content,
      due: due ?? this.due,
      sectionId: sectionId ?? this.sectionId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        isCompleted,
        content,
        due,
        sectionId,
      ];
}
