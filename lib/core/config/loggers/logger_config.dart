import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'custom_pretty_printer.dart';

// class CrashlyticsLogOutput extends LogOutput {

//   final FirebaseCrashlytics crashlytics;

//   CrashlyticsLogOutput(this.crashlytics);

//   @override
//   void output(OutputEvent event) {
//     for (var line in event.lines) {
//       crashlytics.log(line);
//     }
//   }
// }

final Logger logger = Logger(
  filter: ProductionFilter(),
  printer: CustomPrettyPrinter(),
  output: MultiOutput([
    ConsoleOutput(),
    // CrashlyticsLogOutput(FirebaseCrashlytics.instance),
  ]),
);

class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode || event.level.index >= Level.warning.index;
  }
}
