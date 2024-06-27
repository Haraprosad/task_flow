import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:task_flow/core/network/api_client.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/core/network/api_error_handler.dart';
import 'package:task_flow/core/network/network_info.dart';
import 'package:task_flow/flavors/env_config.dart';
import 'package:task_flow/flavors/environment.dart';

// Generate mocks
@GenerateMocks([Dio, ApiErrorHandler, NetworkInfo])
import 'api_client_test.mocks.dart';

void main() {
  late ApiClient apiClient;
  late MockDio mockDio;
  late MockApiErrorHandler mockErrorHandler;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockDio = MockDio();
    mockErrorHandler = MockApiErrorHandler();
    mockNetworkInfo = MockNetworkInfo();

    // Stub the options property
    when(mockDio.options).thenReturn(BaseOptions());

    // Stub the interceptors property
    when(mockDio.interceptors).thenReturn(Interceptors());

    // Set up EnvConfig for testing
    EnvConfig.instantiate(
      baseUrl: 'https://api.example.com',
      environmentType: EnvironmentType.PRODUCTION,
      token: 'mock_token',
      todoSectionId: 'todo_section_id',
      inProgressSectionId: 'in_progress_section_id',
      doneSectionId: 'done_section_id',
    );

    apiClient = ApiClient(mockDio, mockErrorHandler, mockNetworkInfo);
  });

  group('ApiClient', () {
    test('initializes with correct configuration', () {
      expect(EnvConfig.instance.baseUrl, equals('https://api.example.com'));
      expect(EnvConfig.instance.token, equals('mock_token'));
      expect(mockDio.options.baseUrl, equals('https://api.example.com'));
      expect(mockDio.options.headers['Authorization'], equals('Bearer mock_token'));
      expect(mockDio.options.connectTimeout, equals(const Duration(seconds: 15)));
      expect(mockDio.options.receiveTimeout, equals(const Duration(seconds: 15)));
    });

    group('GET request', () {
      test('returns data when the call is successful', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockDio.get<Map<String, dynamic>>('/test', queryParameters: null))
            .thenAnswer((_) async => Response(
                  data: {'key': 'value'},
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/test'),
                ));

        final result = await apiClient.get<Map<String, dynamic>>('/test');

        expect(result, isA<Right<ApiError, Map<String, dynamic>>>());
        expect((result as Right).value, {'key': 'value'});
      });

      test('returns NetworkError when there is no internet connection', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        final result = await apiClient.get<Map<String, dynamic>>('/test');

        expect(result, isA<Left<ApiError, Map<String, dynamic>>>());
        expect((result as Left).value, isA<NetworkError>());
      });

      test('returns ApiError when the call is unsuccessful', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockDio.get<Map<String, dynamic>>('/test', queryParameters: null))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '/test')));
        when(mockErrorHandler.handleError(any)).thenAnswer((_) async => ServerError(code: 500, message: 'Internal Server Error'));

        final result = await apiClient.get<Map<String, dynamic>>('/test');

        expect(result, isA<Left<ApiError, Map<String, dynamic>>>());
        expect((result as Left).value, isA<ServerError>());
      });
    });

    group('POST request', () {
      test('returns data when the call is successful', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockDio.post<Map<String, dynamic>>('/test', data: {'data': 'test'}, queryParameters: null))
            .thenAnswer((_) async => Response(
                  data: {'response': 'success'},
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/test'),
                ));

        final result = await apiClient.post<Map<String, dynamic>>('/test', data: {'data': 'test'});

        expect(result, isA<Right<ApiError, Map<String, dynamic>>>());
        expect((result as Right).value, {'response': 'success'});
      });

      test('returns NetworkError when there is no internet connection', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        final result = await apiClient.post<Map<String, dynamic>>('/test', data: {'data': 'test'});

        expect(result, isA<Left<ApiError, Map<String, dynamic>>>());
        expect((result as Left).value, isA<NetworkError>());
      });

      test('returns ApiError when the call is unsuccessful', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockDio.post<Map<String, dynamic>>('/test', data: {'data': 'test'}, queryParameters: null))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '/test')));
        when(mockErrorHandler.handleError(any)).thenAnswer((_) async => ServerError(code: 500, message: 'Internal Server Error'));

        final result = await apiClient.post<Map<String, dynamic>>('/test', data: {'data': 'test'});

        expect(result, isA<Left<ApiError, Map<String, dynamic>>>());
        expect((result as Left).value, isA<ServerError>());
      });
    });
  
    group('DELETE request', () {
  test('returns Right(null) when the call is successful', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockDio.delete('/test', queryParameters: null))
        .thenAnswer((_) async => Response(
              data: null,
              statusCode: 204,
              requestOptions: RequestOptions(path: '/test'),
            ));

    final result = await apiClient.delete('/test');

    expect(result, isA<Right<ApiError, void>>());
    expect((result as Right).value, isNull);
  });

  test('returns NetworkError when there is no internet connection', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

    final result = await apiClient.delete('/test');

    expect(result, isA<Left<ApiError, void>>());
    expect((result as Left).value, isA<NetworkError>());
  });

  test('returns ApiError when the call is unsuccessful', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockDio.delete('/test', queryParameters: null))
        .thenThrow(DioException(requestOptions: RequestOptions(path: '/test')));
    when(mockErrorHandler.handleError(any)).thenAnswer((_) async => ServerError(code: 500, message: 'Internal Server Error'));

    final result = await apiClient.delete('/test');

    expect(result, isA<Left<ApiError, void>>());
    expect((result as Left).value, isA<ServerError>());
  });

  test('returns Right with data when the call is successful but returns data', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockDio.delete('/test', queryParameters: null))
        .thenAnswer((_) async => Response(
              data: {'message': 'Deleted successfully'},
              statusCode: 200,
              requestOptions: RequestOptions(path: '/test'),
            ));

    final result = await apiClient.delete('/test');

    expect(result, isA<Right<ApiError, dynamic>>());
    expect((result as Right).value, {'message': 'Deleted successfully'});
  });
});
  });
}