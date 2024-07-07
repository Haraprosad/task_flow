import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/domain/repositories/task_repository.dart';
import 'package:task_flow/features/kanban_board/domain/usecases/delete_task.dart';

@GenerateMocks([TaskRepository])
import 'delete_task_test.mocks.dart';

void main() {
  late DeleteTask usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = DeleteTask(mockTaskRepository);
  });

  final tTaskId = '1';
  final tDeletedTask = TaskEntity(id: '1', content: 'Test Task', sectionId: '1', comments: [], duration: 1);

  test('should delete a task when repository call is successful', () async {
    // Arrange
    when(mockTaskRepository.deleteTask(taskId: tTaskId))
        .thenAnswer((_) async => Right(tDeletedTask));

    // Act
    final result = await usecase(DeleteTaskParams(taskId: tTaskId));

    // Assert
    expect(result, Right(tDeletedTask));
    verify(mockTaskRepository.deleteTask(taskId: tTaskId));
    verifyNoMoreInteractions(mockTaskRepository);
  });

  test('should return ApiError when repository call fails', () async {
    // Arrange
    final tApiError = NetworkError();
    when(mockTaskRepository.deleteTask(taskId: tTaskId))
        .thenAnswer((_) async => Left(tApiError));

    // Act
    final result = await usecase(DeleteTaskParams(taskId: tTaskId));

    // Assert
    expect(result, Left(tApiError));
    verify(mockTaskRepository.deleteTask(taskId: tTaskId));
    verifyNoMoreInteractions(mockTaskRepository);
  });
}