import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/core/network/api_error_handler.dart';
import 'package:task_flow/core/network/response_code.dart';


void main() {
  late ApiErrorHandler apiErrorHandler;


  setUp(() {
    apiErrorHandler = ApiErrorHandler();
  });

  group('ApiErrorHandler', () {
    test('should return TimeoutError for connection timeout', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'test_path'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = await apiErrorHandler.handleError(dioError);
      expect(result, isA<TimeoutError>());
      expect(result.code, ResponseCode.CONNECT_TIMEOUT);
    });

    test('should return TimeoutError for send timeout', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'test_path'),
        type: DioExceptionType.sendTimeout,
      );

      final result = await apiErrorHandler.handleError(dioError);
      expect(result, isA<TimeoutError>());
      expect(result.code, ResponseCode.SEND_TIMEOUT);
    });

    test('should return TimeoutError for receive timeout', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'test_path'),
        type: DioExceptionType.receiveTimeout,
      );

      final result = await apiErrorHandler.handleError(dioError);
      expect(result, isA<TimeoutError>());
      expect(result.code, ResponseCode.RECEIVE_TIMEOUT);
    });

    test('should return BadCertificateError for bad certificate', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'test_path'),
        type: DioExceptionType.badCertificate,
        error: 'Certificate error',
      );

      final result = await apiErrorHandler.handleError(dioError);
      expect(result, isA<BadCertificateError>());
    });

    test('should return ConnectionError for connection error', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'test_path'),
        type: DioExceptionType.connectionError,
        error: 'Connection error',
      );

      final result = await apiErrorHandler.handleError(dioError);
      expect(result, isA<ConnectionError>());
    });

    test('should return UnknownError for unknown error', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'test_path'),
        type: DioExceptionType.unknown,
      );

      final result = await apiErrorHandler.handleError(dioError);
      expect(result, isA<UnknownError>());
    });

    test('should return ServerError for bad response', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'test_path'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: 'test_path'),
          statusCode: ResponseCode.BAD_REQUEST,
          data: 'Bad request',
        ),
      );

      final result = await apiErrorHandler.handleError(dioError);
      expect(result, isA<ServerError>());
      expect(result.code, ResponseCode.BAD_REQUEST);
    });

    test('should return UnauthorizedError for unauthorized response', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'test_path'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: 'test_path'),
          statusCode: ResponseCode.UNAUTHORISED,
          data: 'Unauthorized',
        ),
      );

      final result = await apiErrorHandler.handleError(dioError);
      expect(result, isA<UnauthorizedError>());
    });

    test('should return NotFoundError for not found response', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'test_path'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: 'test_path'),
          statusCode: ResponseCode.NOT_FOUND,
          data: 'Not found',
        ),
      );

      final result = await apiErrorHandler.handleError(dioError);
      expect(result, isA<NotFoundError>());
    });

    test('should return ServerError for internal server error response', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'test_path'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: 'test_path'),
          statusCode: ResponseCode.INTERNAL_SERVER_ERROR,
          data: 'Internal server error',
        ),
      );

      final result = await apiErrorHandler.handleError(dioError);
      expect(result, isA<ServerError>());
      expect(result.code, ResponseCode.INTERNAL_SERVER_ERROR);
    });
  });
}
