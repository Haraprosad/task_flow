import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/core/usecases/usecase.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/domain/repositories/task_repository.dart';

class AddTask implements UseCase<TaskEntity, AddTaskParams>{
  final TaskRepository repository;

  AddTask(this.repository);

  @override
  Future<Either<ApiError,TaskEntity>> call(AddTaskParams params) async {
    return repository.addTask(task: params.task);
  }
}

class AddTaskParams extends Equatable {
  final TaskEntity task;

  const AddTaskParams({required this.task});
  
  @override
  List<Object?> get props => [task];
}