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
import 'package:task_flow/core/di/register_module.dart' as _i18;
import 'package:task_flow/core/network/api_client.dart' as _i9;
import 'package:task_flow/core/network/api_error_handler.dart' as _i6;
import 'package:task_flow/core/network/network_info.dart' as _i8;
import 'package:task_flow/features/kanban_board/data/datasources/task_local_datasource.dart'
    as _i7;
import 'package:task_flow/features/kanban_board/data/datasources/task_remote_datasource.dart'
    as _i10;
import 'package:task_flow/features/kanban_board/data/repositories/task_repository_impl.dart'
    as _i12;
import 'package:task_flow/features/kanban_board/domain/repositories/task_repository.dart'
    as _i11;
import 'package:task_flow/features/kanban_board/domain/usecases/add_task.dart'
    as _i14;
import 'package:task_flow/features/kanban_board/domain/usecases/delete_task.dart'
    as _i16;
import 'package:task_flow/features/kanban_board/domain/usecases/get_tasks.dart'
    as _i15;
import 'package:task_flow/features/kanban_board/domain/usecases/update_task.dart'
    as _i13;
import 'package:task_flow/features/kanban_board/presentation/bloc/kanban_board_bloc.dart'
    as _i17;

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
    gh.lazySingleton<_i7.TaskLocalDataSource>(
        () => _i7.TaskLocalDataSourceImpl());
    gh.lazySingleton<_i8.NetworkInfo>(() => _i8.NetworkInfoImpl(
          gh<_i4.InternetConnectionChecker>(),
          gh<_i5.Connectivity>(),
        ));
    gh.lazySingleton<_i9.ApiClient>(() => _i9.ApiClient(
          gh<_i3.Dio>(),
          gh<_i6.ApiErrorHandler>(),
          gh<_i8.NetworkInfo>(),
        ));
    gh.lazySingleton<_i10.TaskRemoteDataSource>(
        () => _i10.TaskRemoteDataSourceImpl(
              gh<_i9.ApiClient>(),
              gh<_i7.TaskLocalDataSource>(),
              gh<_i8.NetworkInfo>(),
            ));
    gh.lazySingleton<_i11.TaskRepository>(() => _i12.TaskRepositoryImpl(
          gh<_i10.TaskRemoteDataSource>(),
          gh<_i7.TaskLocalDataSource>(),
        ));
    gh.lazySingleton<_i13.UpdateTask>(
        () => _i13.UpdateTask(gh<_i11.TaskRepository>()));
    gh.lazySingleton<_i14.AddTask>(
        () => _i14.AddTask(gh<_i11.TaskRepository>()));
    gh.lazySingleton<_i15.GetTasks>(
        () => _i15.GetTasks(gh<_i11.TaskRepository>()));
    gh.lazySingleton<_i16.DeleteTask>(
        () => _i16.DeleteTask(gh<_i11.TaskRepository>()));
    gh.factory<_i17.KanbanBoardBloc>(() => _i17.KanbanBoardBloc(
          getTasks: gh<_i15.GetTasks>(),
          updateTask: gh<_i13.UpdateTask>(),
          addTask: gh<_i14.AddTask>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i18.RegisterModule {}
