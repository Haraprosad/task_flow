// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';
// import 'package:dartz/dartz.dart';
// import 'package:task_flow/core/network/api_error.dart';
// import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
// import 'package:task_flow/features/kanban_board/domain/repositories/task_repository.dart';
// import 'package:task_flow/features/kanban_board/domain/usecases/add_task.dart';

// // Generate a MockTaskRepository using Mockito
// @GenerateMocks([TaskRepository])
// import 'add_task_test.mocks.dart';

// void main() {
//   late AddTask usecase;
//   late MockTaskRepository mockTaskRepository;

//   setUp(() {
//     mockTaskRepository = MockTaskRepository();
//     usecase = AddTask(mockTaskRepository);
//   });

//   final tTask = TaskEntity(
//     id: '1',
//     isCompleted: false,
//     content: 'Test Task',
//     sectionId: 'section1',
//   );

//   test('should add a task when repository call is successful', () async {
//     // Arrange
//     when(mockTaskRepository.addTask(task: tTask))
//         .thenAnswer((_) async => Right(tTask));

//     // Act
//     final result = await usecase(AddTaskParams(task: tTask));

//     // Assert
//     expect(result, Right(tTask));
//     verify(mockTaskRepository.addTask(task: tTask));
//     verifyNoMoreInteractions(mockTaskRepository);
//   });

//   test('should return ApiError when repository call fails', () async {
//     // Arrange
//     final tApiError = NetworkError();
//     when(mockTaskRepository.addTask(task: tTask))
//         .thenAnswer((_) async => Left(tApiError));

//     // Act
//     final result = await usecase(AddTaskParams(task: tTask));

//     // Assert
//     expect(result, Left(tApiError));
//     verify(mockTaskRepository.addTask(task: tTask));
//     verifyNoMoreInteractions(mockTaskRepository);
//   });
// }