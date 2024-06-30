
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@module
abstract class RegisterModule{
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  InternetConnectionChecker get connectionChecker => InternetConnectionChecker();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

}