import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_flow/features/kanban_board/data/models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<void> cacheTasks(List<TaskModel> tasks);
  Future<List<TaskModel>> getCachedTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}

@LazySingleton(as: TaskLocalDataSource)
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const String taskBoxName = 'tasks';

  Future<Box<TaskModel>> _getTaskBox() async {
    if (!Hive.isBoxOpen(taskBoxName)) {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      Hive.registerAdapter(TaskModelAdapter());
      await Hive.openBox<TaskModel>(taskBoxName);
    }
    return Hive.box<TaskModel>(taskBoxName);
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final box = await _getTaskBox();
    await box.clear();
    await box.addAll(tasks);
  }

  @override
  Future<List<TaskModel>> getCachedTasks() async {
    final box = await _getTaskBox();
    return box.values.toList();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    final box = await _getTaskBox();
    await box.put(task.id, task);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final box = await _getTaskBox();
    await box.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final box = await _getTaskBox();
    await box.delete(taskId);
  }
}
