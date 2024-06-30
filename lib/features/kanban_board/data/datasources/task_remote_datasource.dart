import 'package:injectable/injectable.dart';
import 'package:task_flow/core/config/loggers/logger_config.dart';
import 'package:task_flow/core/network/api_client.dart';
import 'package:task_flow/core/network/network_info.dart';
import 'package:task_flow/features/kanban_board/data/models/task_model.dart';
import 'package:task_flow/features/kanban_board/data/datasources/task_local_datasource.dart';


abstract class TaskRemoteDataSource {
  Future<TaskModel> addTask(TaskModel task);
  Future<List<TaskModel>> getTasksBySection(String sectionId);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}

@LazySingleton(as: TaskRemoteDataSource)
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiClient _apiClient;
  final TaskLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  TaskRemoteDataSourceImpl(
      this._apiClient, this._localDataSource, this._networkInfo);

  Future<bool> _hasNetwork() async {
    if (!(await _networkInfo.isConnected)) {
      return false;
    }
    return true;
  }

  Future<List<TaskModel>> _mergeWithLocalData(
      List<TaskModel> remoteTasks) async {
    final localTasks = await _localDataSource.getCachedTasks();
    final Map<String, TaskModel> localTaskMap = {
      for (var task in localTasks) task.id: task
    };

    return remoteTasks.map((remoteTask) {
      final localTask = localTaskMap[remoteTask.id];
      return TaskModel.fromJson(
        remoteTask.toJson(),
        sectionId: localTask?.sectionId,
        comments: localTask?.comments,
        duration: localTask?.duration,
      );
    }).toList();
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    if (await _hasNetwork()) {
      final response = await _apiClient.post<Map<String, dynamic>>(
          '/tasks?project_id=2335312445',
          data: task.toJsonRemote());
      return response.fold(
        (error) => throw error,
        (data) async {
          final remoteTask = TaskModel.fromJson(data,
              sectionId: task.sectionId,
              comments: task.comments,
              duration: task.duration);
          await _localDataSource.addTask(remoteTask);
          return remoteTask;
        },
      );
    } else {
      await _localDataSource.addTask(task);
      return task;
    }
  }

  @override
  Future<List<TaskModel>> getTasksBySection(String sectionId) async {
    if (await _hasNetwork()) {
      final response = await _apiClient.get<List<dynamic>>(
          '/tasks?project_id=2335312445',
          queryParameters: {'section_id': sectionId});
      return response.fold(
        (error) => throw error,
        (data) async {
          final remoteTasks = data
              .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
              .toList();
          final mergedTasks = await _mergeWithLocalData(remoteTasks);
          await _localDataSource.cacheTasks(mergedTasks);
          return mergedTasks;
        },
      );
    } else {
      final tasks = await _localDataSource.getCachedTasks();
      return tasks.where((task) => task.sectionId == sectionId).toList();
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    if (await _hasNetwork()) {
      final response = await _apiClient.update<Map<String, dynamic>>(
          '/tasks/${task.id}',
          data: task.toJsonRemote(),
          hasXRequestedId: true,
          xRequestedId: task.id);
      return response.fold(
        (error) => throw error,
        (data) async {
          final remoteTask = TaskModel.fromJson(data,
              sectionId: task.sectionId,
              comments: task.comments,
              duration: task.duration);
          await _localDataSource.updateTask(remoteTask);
          return remoteTask;
        },
      );
    } else {
      await _localDataSource.updateTask(task);
      return task;
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    if (await _hasNetwork()) {
      final response = await _apiClient.delete('/tasks/$taskId');
      return response.fold(
        (error) => throw error,
        (data) async {
          logger.i("Task deleted successfully");
          await _localDataSource.deleteTask(taskId);
        },
      );
    } else {
      await _localDataSource.deleteTask(taskId);
    }
  }
}
