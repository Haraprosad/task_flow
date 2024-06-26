// API Error
import 'package:easy_localization/easy_localization.dart';
import 'package:task_flow/core/l10n/localization_constants.dart';
import 'package:task_flow/core/network/response_code.dart';


abstract class ApiError implements Exception {
  int get code;
  String get message;
}

class NetworkError extends ApiError {
  @override
  int get code => ResponseCode.NO_INTERNET_CONNECTION;
  @override
  String get message => LocalizationConstants.networkError.tr();
}

class ServerError extends ApiError {
  @override
  final int code;
  @override
  final String message;

  ServerError({required this.code, required this.message});
}

class UnauthorizedError extends ApiError {
  @override
  int get code => ResponseCode.UNAUTHORISED;
  @override
  String get message => LocalizationConstants.authorizationError.tr();
}

class NotFoundError extends ApiError {
  @override
  int get code => ResponseCode.NOT_FOUND;
  @override
  String get message => LocalizationConstants.notFoundError.tr();
}

class TimeoutError extends ApiError {
  @override
  final int code;
  @override
  final String message;

  TimeoutError({required this.code, required this.message});
}

class BadCertificateError extends ApiError {
  @override
  int get code => ResponseCode.BAD_REQUEST;
  @override
  String get message => LocalizationConstants.badCertificateError.tr();
}

class ConnectionError extends ApiError {
  @override
  int get code => ResponseCode.BAD_GATEWAY;
  @override
  String get message => LocalizationConstants.connectionError.tr();
}

class UnknownError extends ApiError {
  @override
  int get code => ResponseCode.DEFAULT;
  @override
  final String message;

  UnknownError({required this.message});
}
