import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectionChecker, this.connectivity);

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> connectivityResult = await connectivity.checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      final isDeviceConnected = await connectionChecker.hasConnection;
      return isDeviceConnected;
    }
    return false;
  }
}
