part of 'kanban_board_bloc.dart';

abstract class KanbanBoardEvent extends Equatable {
  const KanbanBoardEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends KanbanBoardEvent {
  final String sectionId;

  const LoadTasks(this.sectionId);

  @override
  List<Object> get props => [sectionId];
}

class AddNewTask extends KanbanBoardEvent {
  final TaskEntity task;

  const AddNewTask(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateExistingTask extends KanbanBoardEvent {
  final TaskEntity task;

  const UpdateExistingTask(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteExistingTask extends KanbanBoardEvent {
  final String taskId;

  const DeleteExistingTask(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class MoveTask extends KanbanBoardEvent {
  final String taskId;
  final String newSectionId;
  final bool isCompleted;

  const MoveTask({required this.taskId, required this.newSectionId,required this.isCompleted});

  @override
  List<Object> get props => [taskId, newSectionId,isCompleted];
}
