import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/core/usecases/usecase.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/domain/repositories/task_repository.dart';

class UpdateTask implements UseCase<TaskEntity, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<Either<ApiError, TaskEntity>> call(UpdateTaskParams params) async {
    return repository.updateTask(task: params.task);
  }
}

class UpdateTaskParams extends Equatable {
  final TaskEntity task;

  const UpdateTaskParams({required this.task});
  
  @override
  List<Object?> get props => [task];
}