// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i5;
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i4;
import 'package:task_flow/core/di/register_module.dart' as _i17;
import 'package:task_flow/core/network/api_client.dart' as _i8;
import 'package:task_flow/core/network/api_error_handler.dart' as _i6;
import 'package:task_flow/core/network/network_info.dart' as _i7;
import 'package:task_flow/features/kanban_board/data/datasources/task_remote_datasource.dart'
    as _i9;
import 'package:task_flow/features/kanban_board/data/repositories/task_repository_impl.dart'
    as _i11;
import 'package:task_flow/features/kanban_board/domain/repositories/task_repository.dart'
    as _i10;
import 'package:task_flow/features/kanban_board/domain/usecases/add_task.dart'
    as _i13;
import 'package:task_flow/features/kanban_board/domain/usecases/delete_task.dart'
    as _i15;
import 'package:task_flow/features/kanban_board/domain/usecases/get_tasks.dart'
    as _i14;
import 'package:task_flow/features/kanban_board/domain/usecases/update_task.dart'
    as _i12;
import 'package:task_flow/features/kanban_board/presentation/bloc/kanban_board_bloc.dart'
    as _i16;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i3.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i4.InternetConnectionChecker>(
        () => registerModule.connectionChecker);
    gh.lazySingleton<_i5.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i6.ApiErrorHandler>(() => _i6.ApiErrorHandler());
    gh.lazySingleton<_i7.NetworkInfo>(() => _i7.NetworkInfoImpl(
          gh<_i4.InternetConnectionChecker>(),
          gh<_i5.Connectivity>(),
        ));
    gh.lazySingleton<_i8.ApiClient>(() => _i8.ApiClient(
          gh<_i3.Dio>(),
          gh<_i6.ApiErrorHandler>(),
          gh<_i7.NetworkInfo>(),
        ));
    gh.lazySingleton<_i9.TaskRemoteDataSource>(
        () => _i9.TaskRemoteDataSourceImpl(gh<_i8.ApiClient>()));
    gh.lazySingleton<_i10.TaskRepository>(
        () => _i11.TaskRepositoryImpl(gh<_i9.TaskRemoteDataSource>()));
    gh.lazySingleton<_i12.UpdateTask>(
        () => _i12.UpdateTask(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i13.AddTask>(
        () => _i13.AddTask(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i14.GetTasks>(
        () => _i14.GetTasks(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i15.DeleteTask>(
        () => _i15.DeleteTask(gh<_i10.TaskRepository>()));
    gh.factory<_i16.KanbanBoardBloc>(() => _i16.KanbanBoardBloc(
          getTasks: gh<_i14.GetTasks>(),
          updateTask: gh<_i12.UpdateTask>(),
          addTask: gh<_i13.AddTask>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i17.RegisterModule {}
