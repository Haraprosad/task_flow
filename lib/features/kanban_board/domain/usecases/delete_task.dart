import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/core/usecases/usecase.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/domain/repositories/task_repository.dart';

@lazySingleton
class DeleteTask implements UseCase<void, DeleteTaskParams> {
  final TaskRepository repository;

  DeleteTask(this.repository);

  @override
  Future<Either<ApiError, void>> call(DeleteTaskParams params) async {
    return repository.deleteTask(taskId: params.taskId);
  }
}

class DeleteTaskParams extends Equatable {
  final String taskId;

  const DeleteTaskParams({required this.taskId});
  
  @override
  List<Object?> get props => [taskId];
}