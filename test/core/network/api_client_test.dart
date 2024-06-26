import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_flow/core/network/api_client.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/core/network/api_error_handler.dart';
import 'package:task_flow/core/network/network_info.dart';

// Mock classes for dependencies
@GenerateMocks([Dio, ApiErrorHandler, NetworkInfo])
import './api_client_test.mocks.dart';

void main() {
  late ApiClient apiClient;
  late MockDio mockDio;
  late MockApiErrorHandler mockErrorHandler;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockDio = MockDio();
    mockNetworkInfo = MockNetworkInfo();
    mockErrorHandler = MockApiErrorHandler();

    // Stub the interceptors property
    when(mockDio.interceptors).thenReturn(Interceptors());

    apiClient = ApiClient(mockDio, mockErrorHandler, mockNetworkInfo);
  });

  group('ApiClient', () {
    test('get - should return data on successful request', () async {
      // Mock successful response
      when(mockDio.get<String>(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response<String>(
              data: 'test_data',
              statusCode: 200,
              requestOptions: RequestOptions(path: '')));

      // Mock network info isConnected to true
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      final result = await apiClient.get<String>('test_path');
      expect(result.isRight(), true);
      expect(result.fold((error) => error, (data) => data), 'test_data');
    });

    test('get - should return NetworkError when no internet connection', () async {
      // Mock network info isConnected to false
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await apiClient.get<String>('test_path');
      expect(result.isLeft(), true);
      expect(result.fold((error) => error, (data) => data), isA<NetworkError>());
    });

    test('get - should return ApiError on Dio error', () async {
      // Mock network info isConnected to true
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // Mock Dio error
      final dioError = DioException(
        requestOptions: RequestOptions(path: 'test_path'),
        type: DioExceptionType.badResponse,
      );

      when(mockDio.get<String>(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(dioError);

      // Mock error handler response
      when(mockErrorHandler.handleError(dioError))
          .thenAnswer((_) async => ServerError(code: 500, message: 'Internal Server Error'));

      final result = await apiClient.get<String>('test_path');
      expect(result.isLeft(), true);
      expect(result.fold((error) => error, (data) => data), isA<ServerError>());
    });
  });
}