import 'package:logger/logger.dart';
import 'package:ansicolor/ansicolor.dart';

class CustomPrettyPrinter extends PrettyPrinter {
  final AnsiPen _prefixPen = AnsiPen()..green();
  final AnsiPen _infoPen = AnsiPen()..blue();
  final AnsiPen _warningPen = AnsiPen()..yellow();
  final AnsiPen _errorPen = AnsiPen()..red();
  final AnsiPen _defaultPen = AnsiPen()..white();

  @override
  List<String> log(LogEvent event) {
    var emoji = levelEmojis?[event.level] ?? 'ℹ️'; // Default emoji if levelEmojis or specific emoji is null

    var message = '$emoji ${event.message}';

    if (event.level == Level.info) {
      message = _infoPen(message);
    } else if (event.level == Level.warning) {
      message = _warningPen(message);
    } else if (event.level == Level.error) {
      message = _errorPen(message);
    } else {
      message = _defaultPen(message);
    }

    if (event.error != null) {
      message += '\n${event.error}';
    }
    if (event.stackTrace != null) {
      message += '\n${event.stackTrace}';
    }

    return [message];
  }

  String applyPrefix(String message, String prefix) {
    return _prefixPen('$prefix: $message');
  }
}
