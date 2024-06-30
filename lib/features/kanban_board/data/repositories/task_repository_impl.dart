import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/features/kanban_board/data/datasources/task_remote_datasource.dart';
import 'package:task_flow/features/kanban_board/data/datasources/task_local_datasource.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/domain/repositories/task_repository.dart';
import 'package:task_flow/features/kanban_board/data/models/task_model.dart';

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<ApiError, TaskEntity>> addTask({required TaskEntity task}) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        isCompleted: task.isCompleted,
        content: task.content,
        sectionId: task.sectionId ?? 'todo',
        due: task.due,
        comments: task.comments ?? [],
        duration: task.duration ?? 0,
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
        sectionId: task.sectionId ?? 'todo',
        due: task.due,
        comments: task.comments ?? [],
        duration: task.duration ?? 0,
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
      await remoteDataSource.deleteTask(taskId);
      return const Right(null);
    } on ApiError catch (error) {
      return Left(error);
    }
  }
}
