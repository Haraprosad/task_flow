import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:task_flow/core/config/loggers/logger_config.dart';
import 'package:task_flow/core/constants/app_values.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/core/network/api_error_handler.dart';
import 'package:task_flow/core/network/network_info.dart';
import 'package:task_flow/flavors/env_config.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

@lazySingleton
class ApiClient {
  final Dio _dio;
  final ApiErrorHandler _errorHandler;
  final NetworkInfo _networkInfo;

  ApiClient(this._dio, this._errorHandler, this._networkInfo) {
    final EnvConfig envConfig = EnvConfig.instance;
    _dio.options.baseUrl = envConfig.baseUrl;
    _dio.options.headers['Authorization'] = 'Bearer ${envConfig.token}';
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.connectTimeout =
        const Duration(seconds: AppValues.connectionTimeout);
    _dio.options.receiveTimeout =
        const Duration(seconds: AppValues.receiveTimeout);

    _dio.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: false,
          printResponseMessage: true,
        ),
      ),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.i('Request: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.i('Response: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        logger.e('Dio error: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  Future<Either<ApiError, T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters}) async {
    if (!(await _networkInfo.isConnected)) {
      logger.w('No internet connection');
      return Left(NetworkError());
    }

    try {
      final response =
          await _dio.get<T>(path, queryParameters: queryParameters);
      return Right(response.data as T);
    } catch (error) {
      final apiError = await _errorHandler.handleError(error);
      return Left(apiError);
    }
  }

  Future<Either<ApiError, T>> post<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    if (!(await _networkInfo.isConnected)) {
      logger.w('No internet connection');
      return Left(NetworkError());
    }

    try {
      final response = await _dio.post<T>(path,
          data: data, queryParameters: queryParameters);
      return Right(response.data as T);
    } catch (error) {
      final apiError = await _errorHandler.handleError(error);
      return Left(apiError);
    }
  }

  Future<Either<ApiError, T>> update<T>(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      bool hasXRequestedId = false,
      String xRequestedId = ""}) async {
    if (hasXRequestedId) {
      _dio.options.headers['X-Request-Id'] = xRequestedId;
    }
    if (!(await _networkInfo.isConnected)) {
      logger.w('No internet connection');
      return Left(NetworkError());
    }

    try {
      final response = await _dio.post<T>(path,
          data: data, queryParameters: queryParameters);
      return Right(response.data as T);
    } catch (error) {
      final apiError = await _errorHandler.handleError(error);
      return Left(apiError);
    }
  }

  //Delete
  Future<Either<ApiError, void>> delete(String path,
      {Map<String, dynamic>? queryParameters}) async {
    if (!(await _networkInfo.isConnected)) {
      logger.w('No internet connection');
      return Left(NetworkError());
    }

    try {
      final response =
          await _dio.delete(path, queryParameters: queryParameters);
      if (response.statusCode == 204) {
        return const Right(null); // Since T can be void, this is safe.
      }
      return const Right(
          null); // If there is data, but typically it's not expected.
    } catch (error) {
      final apiError = await _errorHandler.handleError(error);
      return Left(apiError);
    }
  }
}
