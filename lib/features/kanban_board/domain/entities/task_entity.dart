import 'package:equatable/equatable.dart';
import 'due.dart';

class TaskEntity extends Equatable {
  final String id;
  final bool isCompleted;
  final String content;
  final Due? due;
  final String sectionId;

  const TaskEntity({
    required this.id,
    required this.isCompleted,
    required this.content,
    this.due,
    required this.sectionId,
  });

  @override
  List<Object?> get props => [
        id,
        isCompleted,
        content,
        due,
        sectionId,
      ];
}
