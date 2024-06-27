import 'package:dartz/dartz.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/features/kanban_board/data/datasources/task_remote_datasource.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/domain/repositories/task_repository.dart';
import 'package:task_flow/features/kanban_board/data/models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<ApiError, TaskEntity>> addTask({required TaskEntity task}) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        isCompleted: task.isCompleted,
        content: task.content,
        sectionId: task.sectionId,
        due: task.due,
      );
      final result = await remoteDataSource.addTask(taskModel);
      return Right(result);
    } on ApiError catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<ApiError, List<TaskEntity>>> getTasksBySection({required String sectionId}) async {
    try {
      final result = await remoteDataSource.getTasksBySection(sectionId);
      return Right(result);
    } on ApiError catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<ApiError, TaskEntity>> updateTask({required TaskEntity task}) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        isCompleted: task.isCompleted,
        content: task.content,
        sectionId: task.sectionId,
        due: task.due,
      );
      final result = await remoteDataSource.updateTask(taskModel);
      return Right(result);
    } on ApiError catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<ApiError, void>> deleteTask({required String taskId}) async {
    try {
      final result = await remoteDataSource.deleteTask(taskId);
      return Right(result);
    } on ApiError catch (error) {
      return Left(error);
    }
  }
}