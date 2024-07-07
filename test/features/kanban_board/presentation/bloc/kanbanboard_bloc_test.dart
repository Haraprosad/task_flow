import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/domain/usecases/get_tasks.dart';
import 'package:task_flow/features/kanban_board/domain/usecases/update_task.dart';
import 'package:task_flow/features/kanban_board/domain/usecases/add_task.dart';
import 'package:task_flow/features/kanban_board/presentation/bloc/kanban_board_bloc.dart';
import 'kanban_board_bloc_test.mocks.dart';

@GenerateMocks([GetTasks, UpdateTask, AddTask])

void main() {
  late KanbanBoardBloc bloc;
  late MockGetTasks mockGetTasks;
  late MockUpdateTask mockUpdateTask;
  late MockAddTask mockAddTask;

  setUp(() {
    mockGetTasks = MockGetTasks();
    mockUpdateTask = MockUpdateTask();
    mockAddTask = MockAddTask();
    bloc = KanbanBoardBloc(
      getTasks: mockGetTasks,
      updateTask: mockUpdateTask,
      addTask: mockAddTask,
    );
  });

  final tTask = TaskEntity(id: '1', content: 'Test Task', sectionId: '1', comments: [], duration: 1);
  final tTasks = [tTask];
  final tSectionId = '1';

  group('LoadTasks', () {
    blocTest<KanbanBoardBloc, KanbanBoardState>(
      'emits [KanbanBoardLoading, KanbanBoardLoaded] when LoadTasks is added and getTasks succeeds',
      build: () {
        when(mockGetTasks(GetTasksParams(sectionId: tSectionId)))
            .thenAnswer((_) async => Right(tTasks));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTasks(tSectionId)),
      expect: () => [
        KanbanBoardLoading(),
        KanbanBoardLoaded(tasks: tTasks),
      ],
      verify: (_) {
        verify(mockGetTasks(GetTasksParams(sectionId: tSectionId)));
        verifyNoMoreInteractions(mockGetTasks);
      },
    );

    blocTest<KanbanBoardBloc, KanbanBoardState>(
      'emits [KanbanBoardLoading, KanbanBoardError] when LoadTasks is added and getTasks fails',
      build: () {
        when(mockGetTasks(GetTasksParams(sectionId: tSectionId)))
            .thenAnswer((_) async => Left(NetworkError()));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTasks(tSectionId)),
      expect: () => [
        KanbanBoardLoading(),
        KanbanBoardError(message: NetworkError().message),
      ],
      verify: (_) {
        verify(mockGetTasks(GetTasksParams(sectionId: tSectionId)));
        verifyNoMoreInteractions(mockGetTasks);
      },
    );
  });

  group('AddNewTask', () {
    blocTest<KanbanBoardBloc, KanbanBoardState>(
      'emits [KanbanBoardLoaded] with updated tasks when AddNewTask is added and addTask succeeds',
      build: () {
        when(mockAddTask(AddTaskParams(task: tTask)))
            .thenAnswer((_) async => Right(tTask));
        return bloc;
      },
      seed: () => KanbanBoardLoaded(tasks: []),
      act: (bloc) => bloc.add(AddNewTask(tTask)),
      expect: () => [
        KanbanBoardLoaded(tasks: [tTask]),
      ],
      verify: (_) {
        verify(mockAddTask(AddTaskParams(task: tTask)));
        verifyNoMoreInteractions(mockAddTask);
      },
    );

    blocTest<KanbanBoardBloc, KanbanBoardState>(
      'emits [KanbanBoardError] when AddNewTask is added and addTask fails',
      build: () {
        when(mockAddTask(AddTaskParams(task: tTask)))
            .thenAnswer((_) async => Left(NetworkError()));
        return bloc;
      },
      seed: () => KanbanBoardLoaded(tasks: []),
      act: (bloc) => bloc.add(AddNewTask(tTask)),
      expect: () => [
        KanbanBoardError(message: NetworkError().message),
      ],
      verify: (_) {
        verify(mockAddTask(AddTaskParams(task: tTask)));
        verifyNoMoreInteractions(mockAddTask);
      },
    );
  });

  group('UpdateExistingTask', () {
    final updatedTask = tTask.copyWith(content: 'Updated Task');

    blocTest<KanbanBoardBloc, KanbanBoardState>(
      'emits [KanbanBoardLoaded] with updated task when UpdateExistingTask is added and updateTask succeeds',
      build: () {
        when(mockUpdateTask(UpdateTaskParams(task: updatedTask)))
            .thenAnswer((_) async => Right(updatedTask));
        return bloc;
      },
      seed: () => KanbanBoardLoaded(tasks: [tTask]),
      act: (bloc) => bloc.add(UpdateExistingTask(updatedTask)),
      expect: () => [
        KanbanBoardLoaded(tasks: [updatedTask]),
      ],
      verify: (_) {
        verify(mockUpdateTask(UpdateTaskParams(task: updatedTask)));
        verifyNoMoreInteractions(mockUpdateTask);
      },
    );

    blocTest<KanbanBoardBloc, KanbanBoardState>(
      'emits [KanbanBoardError] when UpdateExistingTask is added and updateTask fails',
      build: () {
        when(mockUpdateTask(UpdateTaskParams(task: updatedTask)))
            .thenAnswer((_) async => Left(NetworkError()));
        return bloc;
      },
      seed: () => KanbanBoardLoaded(tasks: [tTask]),
      act: (bloc) => bloc.add(UpdateExistingTask(updatedTask)),
      expect: () => [
        KanbanBoardError(message: NetworkError().message),
      ],
      verify: (_) {
        verify(mockUpdateTask(UpdateTaskParams(task: updatedTask)));
        verifyNoMoreInteractions(mockUpdateTask);
      },
    );
  });
}
