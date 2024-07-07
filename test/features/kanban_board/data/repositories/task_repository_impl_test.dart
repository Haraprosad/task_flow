import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/features/kanban_board/data/datasources/task_local_datasource.dart';
import 'package:task_flow/features/kanban_board/data/datasources/task_remote_datasource.dart';
import 'package:task_flow/features/kanban_board/data/models/task_model.dart';
import 'package:task_flow/features/kanban_board/data/repositories/task_repository_impl.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';

@GenerateMocks([TaskRemoteDataSource, TaskLocalDataSource])
import 'task_repository_impl_test.mocks.dart';

void main() {
  late TaskRepositoryImpl repository;
  late MockTaskRemoteDataSource mockRemoteDataSource;
  late MockTaskLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTaskRemoteDataSource();
    mockLocalDataSource = MockTaskLocalDataSource();
    repository = TaskRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  group('addTask', () {
    test(
        'should return Right(TaskEntity) when the call to remote data source is successful',
        () async {
      // Arrange
      final taskEntity = TaskEntity(
          id: '1',
          content: 'Test Task',
          sectionId: '1',
          comments: [],
          duration: 1);
      final taskModel = TaskModel(
          id: '1',
          content: 'Test Task',
          sectionId: '1',
          comments: [],
          duration: 1);
      when(mockRemoteDataSource.addTask(any))
          .thenAnswer((_) async => taskModel);

      // Act
      final result = await repository.addTask(task: taskEntity);

      // Assert
      expect(result, Right(taskModel));
      verify(mockRemoteDataSource.addTask(any)).called(1);
    });

    test(
        'should return Left(NetworkError) when there is no internet connection',
        () async {
      // Arrange
      final taskEntity = TaskEntity(id: '1', content: 'Test Task', sectionId: '1', comments: [], duration: 1);
      when(mockRemoteDataSource.addTask(any)).thenThrow(NetworkError());

      // Act
      final result = await repository.addTask(task: taskEntity);

      // Assert
      expect(result.isLeft(), true);
      expect((result as Left).value, isA<NetworkError>());
      verify(mockRemoteDataSource.addTask(any)).called(1);
    });

    test('should return Left(ServerError) when the server returns an error',
        () async {
      // Arrange
      final taskEntity = TaskEntity(id: '1', content: 'Test Task', sectionId: '1', comments: [], duration: 1);
      when(mockRemoteDataSource.addTask(any))
          .thenThrow(ServerError(code: 500, message: 'Internal Server Error'));

      // Act
      final result = await repository.addTask(task: taskEntity);

      // Assert
      expect(result.isLeft(), true);
      expect((result as Left).value, isA<ServerError>());
      verify(mockRemoteDataSource.addTask(any)).called(1);
    });
  });

  group('getTasksBySection', () {
    test(
        'should return Right(List<TaskEntity>) when the call to remote data source is successful',
        () async {
      // Arrange
      final taskModels = [
        TaskModel(id: '1', content: 'Test Task', sectionId: '1', comments: [], duration: 1),
        TaskModel(id: '2', content: 'Test Task', sectionId: '1', comments: [], duration: 1),
      ];
      when(mockRemoteDataSource.getTasksBySection(any))
          .thenAnswer((_) async => taskModels);

      // Act
      final result = await repository.getTasksBySection(sectionId: 'section1');

      // Assert
      expect(result, Right(taskModels));
      verify(mockRemoteDataSource.getTasksBySection('section1')).called(1);
    });

    test('should return Left(NotFoundError) when the section is not found',
        () async {
      // Arrange
      when(mockRemoteDataSource.getTasksBySection(any))
          .thenThrow(NotFoundError());

      // Act
      final result =
          await repository.getTasksBySection(sectionId: 'nonexistent');

      // Assert
      expect(result.isLeft(), true);
      expect((result as Left).value, isA<NotFoundError>());
      verify(mockRemoteDataSource.getTasksBySection('nonexistent')).called(1);
    });
  });

  group('updateTask', () {
    test(
        'should return Right(TaskEntity) when the call to remote data source is successful',
        () async {
      // Arrange
      final taskEntity = TaskEntity(id: '1', content: 'Test Task', sectionId: '1', comments: [], duration: 1);
      final taskModel = TaskModel(id: '1', content: 'Test Task', sectionId: '1', comments: [], duration: 1);
      when(mockRemoteDataSource.updateTask(any))
          .thenAnswer((_) async => taskModel);

      // Act
      final result = await repository.updateTask(task: taskEntity);

      // Assert
      expect(result, Right(taskModel));
      verify(mockRemoteDataSource.updateTask(any)).called(1);
    });

    test(
        'should return Left(UnauthorizedError) when the user is not authorized',
        () async {
      // Arrange
      final taskEntity = TaskEntity(id: '1', content: 'Test Task', sectionId: '1', comments: [], duration: 1);
      when(mockRemoteDataSource.updateTask(any)).thenThrow(UnauthorizedError());

      // Act
      final result = await repository.updateTask(task: taskEntity);

      // Assert
      expect(result.isLeft(), true);
      expect((result as Left).value, isA<UnauthorizedError>());
      verify(mockRemoteDataSource.updateTask(any)).called(1);
    });
  });

  group('deleteTask', () {
    test(
        'should return Right(null) when the call to remote data source is successful',
        () async {
      // Arrange
      when(mockRemoteDataSource.deleteTask(any)).thenAnswer((_) async => null);

      // Act
      final result = await repository.deleteTask(taskId: '1');

      // Assert
      expect(result, equals(const Right<ApiError, void>(null)));
      verify(mockRemoteDataSource.deleteTask('1')).called(1);
    });

    test('should return Left(TimeoutError) when the request times out',
        () async {
      // Arrange
      when(mockRemoteDataSource.deleteTask(any))
          .thenThrow(TimeoutError(code: 408, message: 'Request Timeout'));

      // Act
      final result = await repository.deleteTask(taskId: '1');

      // Assert
      expect(result.isLeft(), true);
      expect((result as Left).value, isA<TimeoutError>());
      verify(mockRemoteDataSource.deleteTask('1')).called(1);
    });
  });
}
