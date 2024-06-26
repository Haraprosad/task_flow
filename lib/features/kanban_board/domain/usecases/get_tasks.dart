import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/core/usecases/usecase.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/domain/repositories/task_repository.dart';

class GetTasks implements UseCase<List<TaskEntity>, GetTasksParams> {
  final TaskRepository repository;

  GetTasks(this.repository);

  @override
  Future<Either<ApiError, List<TaskEntity>>> call(GetTasksParams params) async {
    return repository.getTasksBySection(sectionId: params.sectionId);
  }
}

class GetTasksParams extends Equatable {
  final String sectionId;

  const GetTasksParams({required this.sectionId});
  
  @override
  List<Object?> get props => [sectionId];
}