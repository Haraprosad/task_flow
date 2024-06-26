import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:task_flow/core/config/loggers/logger_config.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/core/network/api_error_handler.dart';
import 'package:task_flow/core/network/network_info.dart';

class ApiClient {
  final Dio _dio;
  final ApiErrorHandler _errorHandler;
  final NetworkInfo _networkInfo;

  ApiClient(this._dio, this._errorHandler, this._networkInfo) {
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

  Future<Either<ApiError,T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    if (!(await _networkInfo.isConnected)) {
      logger.w('No internet connection');
      return Left(NetworkError());
    }

    try {
      final response = await _dio.get<T>(path, queryParameters: queryParameters);
      return Right(response.data as T);
    } catch (error) {
      final apiError = await _errorHandler.handleError(error);
      return Left(apiError);
    }
  }

  Future<Either<ApiError,T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    if (!(await _networkInfo.isConnected)) {
      logger.w('No internet connection');
      return Left(NetworkError());
    }

    try {
      final response = await _dio.post<T>(path, data: data, queryParameters: queryParameters);
      return Right(response.data as T);
    } catch (error) {
      final apiError = await _errorHandler.handleError(error);
      return Left(apiError);
    }
  }

  // Implement other methods (put, delete) similarly
}
