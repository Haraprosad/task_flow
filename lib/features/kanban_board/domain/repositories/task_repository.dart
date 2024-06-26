import 'package:dartz/dartz.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';

abstract class TaskRepository{
  Future<Either<ApiError,TaskEntity>> addTask({required TaskEntity task});
  Future<Either<ApiError,List<TaskEntity>>> getTasksBySection({required String sectionId});
  Future<Either<ApiError,TaskEntity>> updateTask({required TaskEntity task});
  Future<Either<ApiError,TaskEntity>> deleteTask({required String taskId});
}