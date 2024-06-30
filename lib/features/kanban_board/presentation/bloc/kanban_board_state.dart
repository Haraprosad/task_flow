part of 'kanban_board_bloc.dart';

abstract class KanbanBoardState extends Equatable {
  const KanbanBoardState();
  
  @override
  List<Object> get props => [];
}

class KanbanBoardInitial extends KanbanBoardState {}

class KanbanBoardLoading extends KanbanBoardState {}

class KanbanBoardLoaded extends KanbanBoardState {
  final List<TaskEntity> tasks;

  const KanbanBoardLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class KanbanBoardError extends KanbanBoardState {
  final String message;

  const KanbanBoardError({required this.message});

  @override
  List<Object> get props => [message];
}