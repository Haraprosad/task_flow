import 'package:injectable/injectable.dart';
import 'package:task_flow/core/config/loggers/logger_config.dart';
import 'package:task_flow/core/network/api_client.dart';
import 'package:task_flow/features/kanban_board/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<TaskModel> addTask(TaskModel task);
  Future<List<TaskModel>> getTasksBySection(String sectionId);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}

@LazySingleton(as: TaskRemoteDataSource)
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiClient _apiClient;

  TaskRemoteDataSourceImpl(this._apiClient);

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    final response = await _apiClient.post<Map<String, dynamic>>('/tasks?project_id=2335312445',
        data: task.toJson());
    return response.fold(
      (error) => throw error,
      (data) => TaskModel.fromJson(data),
    );
  }

  @override
  Future<List<TaskModel>> getTasksBySection(String sectionId) async {
    final response = await _apiClient.get<List<dynamic>>('/tasks?project_id=2335312445',
        queryParameters: {'section_id': sectionId});
    return response.fold(
      (error) => throw error,
      (data) => data
          .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await _apiClient
        .update<Map<String, dynamic>>('/tasks/${task.id}', data: task.toJson(),hasXRequestedId: true, xRequestedId: task.id);
    return response.fold(
      (error) => throw error,
      (data) => TaskModel.fromJson(data),
    );
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final response = await _apiClient.delete('/tasks/$taskId');
    return response.fold(
      (error) => throw error,
      (data) {
        logger.i("Task deleted successfully");
        return;
      },
    );
  }
}
