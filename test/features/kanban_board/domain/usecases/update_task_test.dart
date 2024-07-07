import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/domain/repositories/task_repository.dart';
import 'package:task_flow/features/kanban_board/domain/usecases/update_task.dart';

@GenerateMocks([TaskRepository])
import 'update_task_test.mocks.dart';

void main() {
  late UpdateTask usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = UpdateTask(mockTaskRepository);
  });

  final tTask =  TaskEntity(id: '1', content: 'Test Task', sectionId: '1', comments: [], duration: 1);

  test('should update a task when repository call is successful', () async {
    // Arrange
    when(mockTaskRepository.updateTask(task: tTask))
        .thenAnswer((_) async => Right(tTask));

    // Act
    final result = await usecase(UpdateTaskParams(task: tTask));

    // Assert
    expect(result, Right(tTask));
    verify(mockTaskRepository.updateTask(task: tTask));
    verifyNoMoreInteractions(mockTaskRepository);
  });

  test('should return ApiError when repository call fails', () async {
    // Arrange
    final tApiError = NetworkError();
    when(mockTaskRepository.updateTask(task: tTask))
        .thenAnswer((_) async => Left(tApiError));

    // Act
    final result = await usecase(UpdateTaskParams(task: tTask));

    // Assert
    expect(result, Left(tApiError));
    verify(mockTaskRepository.updateTask(task: tTask));
    verifyNoMoreInteractions(mockTaskRepository);
  });
}