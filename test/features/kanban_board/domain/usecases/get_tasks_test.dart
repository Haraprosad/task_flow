import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/domain/repositories/task_repository.dart';
import 'package:task_flow/features/kanban_board/domain/usecases/get_tasks.dart';

@GenerateMocks([TaskRepository])
import 'get_tasks_test.mocks.dart';

void main() {
  late GetTasks usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = GetTasks(mockTaskRepository);
  });

  final tSectionId = 'section1';
  final tTasks = [
     TaskEntity(id: '1', content: 'Test Task', sectionId: '1', comments: [], duration: 1),
     TaskEntity(id: '2', content: 'Test Task2', sectionId: '1', comments: [], duration: 1)
  ];

  test('should get tasks when repository call is successful', () async {
    // Arrange
    when(mockTaskRepository.getTasksBySection(sectionId: tSectionId))
        .thenAnswer((_) async => Right(tTasks));

    // Act
    final result = await usecase(GetTasksParams(sectionId: tSectionId));

    // Assert
    expect(result, Right(tTasks));
    verify(mockTaskRepository.getTasksBySection(sectionId: tSectionId));
    verifyNoMoreInteractions(mockTaskRepository);
  });

  test('should return ApiError when repository call fails', () async {
    // Arrange
    final tApiError = NetworkError();
    when(mockTaskRepository.getTasksBySection(sectionId: tSectionId))
        .thenAnswer((_) async => Left(tApiError));

    // Act
    final result = await usecase(GetTasksParams(sectionId: tSectionId));

    // Assert
    expect(result, Left(tApiError));
    verify(mockTaskRepository.getTasksBySection(sectionId: tSectionId));
    verifyNoMoreInteractions(mockTaskRepository);
  });
}