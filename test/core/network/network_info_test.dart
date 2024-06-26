import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Adjust the path accordingly
import 'package:task_flow/core/network/network_info.dart';

@GenerateMocks([InternetConnectionChecker, Connectivity])
import './network_info_test.mocks.dart';

void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockConnectionChecker;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectionChecker = MockInternetConnectionChecker();
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectionChecker, mockConnectivity);
  });

  group('isConnected', () {
    test('should return true when connected to the internet', () async {
      // arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.mobile]);
      when(mockConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, true);
    });

    test('should return false when not connected to the internet', () async {
      // arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, false);
    });

    test('should return false when connectivity result is not none but no internet connection', () async {
      // arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, false);
    });
  });
}
