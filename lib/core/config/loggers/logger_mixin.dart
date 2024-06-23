import 'custom_pretty_printer.dart';
import 'logger_config.dart';

mixin LoggerMixin {
  String get logPrefix;

  void debugLog(String message) {
    logger.d(CustomPrettyPrinter().applyPrefix(message, logPrefix));
  }

  void infoLog(String message) {
    logger.i(CustomPrettyPrinter().applyPrefix(message, logPrefix));
  }

  void warningLog(String message) {
    logger.w(CustomPrettyPrinter().applyPrefix(message, logPrefix));
  }

  void errorLog(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.e(CustomPrettyPrinter().applyPrefix(message, logPrefix),error: error, stackTrace: stackTrace);
  }
}
