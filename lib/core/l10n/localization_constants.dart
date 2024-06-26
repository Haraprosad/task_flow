class LocalizationConstants {
  // Private prefixes for different categories of localization keys
  static const String _errorMessagesPrefix = "error_messages.";
  static const String _errorActionsPrefix = "error_actions.";
  static const String _errorTitlesPrefix = "error_titles.";

  // Error Messages
  static const String networkError = "${_errorMessagesPrefix}network_error";
  static const String connectionTimeoutError = "${_errorMessagesPrefix}connection_timeout_error";
  static const String sendTimeoutError = "${_errorMessagesPrefix}send_timeout_error";
  static const String receiveTimeoutError = "${_errorMessagesPrefix}receive_timeout_error";
  static const String serverError = "${_errorMessagesPrefix}server_error";
  static const String authenticationError = "${_errorMessagesPrefix}authentication_error";
  static const String authorizationError = "${_errorMessagesPrefix}authorization_error";
  static const String notFoundError = "${_errorMessagesPrefix}not_found_error";
  static const String validationError = "${_errorMessagesPrefix}validation_error";
  static const String rateLimitError = "${_errorMessagesPrefix}rate_limit_error";
  static const String badRequestError = "${_errorMessagesPrefix}bad_request_error";
  static const String conflictError = "${_errorMessagesPrefix}conflict_error";
  static const String serviceUnavailable = "${_errorMessagesPrefix}service_unavailable";
  static const String unknownError = "${_errorMessagesPrefix}unknown_error";
  static const String parsingError = "${_errorMessagesPrefix}parsing_error";
  static const String offlineError = "${_errorMessagesPrefix}offline_error";
  static const String apiDeprecated = "${_errorMessagesPrefix}api_deprecated";
  static const String maintenanceError = "${_errorMessagesPrefix}maintenance_error";
  static const String quotaExceeded = "${_errorMessagesPrefix}quota_exceeded";
  static const String badCertificateError = "${_errorMessagesPrefix}bad_certificate_error";
  static const String forbiddenError = "${_errorMessagesPrefix}forbidden_error";

  // Error Actions
  static const String tryAgain = "${_errorActionsPrefix}try_again";
  static const String cancel = "${_errorActionsPrefix}cancel";
  static const String goBack = "${_errorActionsPrefix}go_back";
  static const String refresh = "${_errorActionsPrefix}refresh";
  static const String contactSupport = "${_errorActionsPrefix}contact_support";

  // Error Titles
  static const String connectionError = "${_errorTitlesPrefix}connection_error";
  static const String serverErrorTitle = "${_errorTitlesPrefix}server_error";
  static const String clientErrorTitle = "${_errorTitlesPrefix}client_error";
  static const String authenticationErrorTitle = "${_errorTitlesPrefix}authentication_error";
  static const String unknownErrorTitle = "${_errorTitlesPrefix}unknown_error";

  // Other
  static const String tryAgainLater = "try_again_later";
  static const String taskFlow = "task_flow";
}
