import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/domain/usecases/get_tasks.dart';
import 'package:task_flow/features/kanban_board/domain/usecases/update_task.dart';
import 'package:task_flow/features/kanban_board/domain/usecases/add_task.dart';

part 'kanban_board_event.dart';
part 'kanban_board_state.dart';

@injectable
class KanbanBoardBloc extends Bloc<KanbanBoardEvent, KanbanBoardState> {
  final GetTasks getTasks;
  final UpdateTask updateTask;
  final AddTask addTask;

  KanbanBoardBloc({
    required this.getTasks,
    required this.updateTask,
    required this.addTask,
  }) : super(KanbanBoardInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddNewTask>(_onAddNewTask);
    on<UpdateExistingTask>(_onUpdateExistingTask);
    on<MoveTask>(_onMoveTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<KanbanBoardState> emit) async {
    emit(KanbanBoardLoading());
    final result = await getTasks(GetTasksParams(sectionId: event.sectionId));
    result.fold(
      (failure) => emit(KanbanBoardError(message: failure.message)),
      (tasks) => emit(KanbanBoardLoaded(tasks: tasks)),
    );
  }

  Future<void> _onAddNewTask(AddNewTask event, Emitter<KanbanBoardState> emit) async {
    final currentState = state;
    if (currentState is KanbanBoardLoaded) {
      final result = await addTask(AddTaskParams(task: event.task));
      result.fold(
        (failure) => emit(KanbanBoardError(message: failure.message)),
        (task) {
          final updatedTasks = List<TaskEntity>.from(currentState.tasks)..add(task);
          emit(KanbanBoardLoaded(tasks: updatedTasks));
        },
      );
    }
  }

  Future<void> _onUpdateExistingTask(UpdateExistingTask event, Emitter<KanbanBoardState> emit) async {
    final currentState = state;
    if (currentState is KanbanBoardLoaded) {
      final result = await updateTask(UpdateTaskParams(task: event.task));
      result.fold(
        (failure) => emit(KanbanBoardError(message: failure.message)),
        (updatedTask) {
          final updatedTasks = currentState.tasks.map((task) => 
            task.id == updatedTask.id ? updatedTask : task
          ).toList();
          emit(KanbanBoardLoaded(tasks: updatedTasks));
        },
      );
    }
  }

  Future<void> _onMoveTask(MoveTask event, Emitter<KanbanBoardState> emit) async {
    final currentState = state;
    if (currentState is KanbanBoardLoaded) {
      final taskToMove = currentState.tasks.firstWhere((task) => task.id == event.newTaskEntity.id);
      final updatedTask = taskToMove.copyWith(
        sectionId: event.newTaskEntity.sectionId,
        // isCompleted: event.newTaskEntity.isCompleted,
        // duration: event.newTaskEntity.duration,
        // completedAt: event.newTaskEntity.completedAt,
      );
      add(UpdateExistingTask(updatedTask));
    }
  }
}