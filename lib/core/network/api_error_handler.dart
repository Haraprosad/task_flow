import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_flow/core/config/loggers/logger_config.dart';
import 'package:task_flow/core/l10n/localization_constants.dart';
import 'package:task_flow/core/network/api_error.dart';
import 'package:task_flow/core/network/network_info.dart';
import 'package:task_flow/core/network/response_code.dart';

class ApiErrorHandler {
  

  Future<ApiError> handleError(dynamic error) async {
    if (error is DioException) {
      return _handleDioError(error);
    } else {
      logger.e('Unknown error: $error');
      return UnknownError(message: LocalizationConstants.unknownError.tr());
    }
  }

 Future<ApiError> _handleDioError(DioException error) async {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      logger.e('Connection timeout occurred');
      return TimeoutError(code: ResponseCode.CONNECT_TIMEOUT, message: LocalizationConstants.connectionTimeoutError.tr());
    case DioExceptionType.sendTimeout:
      logger.e('Send timeout occurred');
      return TimeoutError(code: ResponseCode.SEND_TIMEOUT, message: LocalizationConstants.sendTimeoutError.tr());
    case DioExceptionType.receiveTimeout:
      logger.e('Receive timeout occurred');
      return TimeoutError(code: ResponseCode.RECEIVE_TIMEOUT, message: LocalizationConstants.receiveTimeoutError.tr());
    case DioExceptionType.badCertificate:
      logger.e('Bad certificate error: ${error.message}');
      return BadCertificateError();
    case DioExceptionType.connectionError:
      logger.e('Connection error: ${error.message}');
      return ConnectionError();
    case DioExceptionType.badResponse:
      return _handleBadResponse(error.response!);
    case DioExceptionType.cancel:
      logger.w('Request cancelled');
      return UnknownError(message: LocalizationConstants.cancel.tr());
    default:
      logger.e('Dio error: ${error.message}');
      return UnknownError(message:LocalizationConstants.unknownError.tr());
  }
}


  ApiError _handleBadResponse(Response response) {
    logger.e('Bad response: ${response.statusCode}, ${response.data}');
    switch (response.statusCode) {
      case ResponseCode.BAD_REQUEST:
        return ServerError(code:ResponseCode.BAD_REQUEST, message: LocalizationConstants.badRequestError.tr());
      case ResponseCode.UNAUTHORISED:
        return UnauthorizedError();
      case ResponseCode.FORBIDDEN:
        return ServerError(code:ResponseCode.FORBIDDEN, message: LocalizationConstants.forbiddenError.tr());
      case ResponseCode.NOT_FOUND:
        return NotFoundError();
      case ResponseCode.INTERNAL_SERVER_ERROR:
        return ServerError(code:ResponseCode.INTERNAL_SERVER_ERROR,message: LocalizationConstants.serverError.tr());
      default:
        return ServerError(code:ResponseCode.DEFAULT,message: LocalizationConstants.unknownError.tr());
    }
  }
}