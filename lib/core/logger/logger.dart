import 'dart:developer' as developer;

import 'package:logging/logging.dart';

///
final Logger logger = Logger('Digital_Dairy');

/// Initializes the logging system.
///
/// [level] defines the minimum log level to capture.
void initLogger({required Level level}) {
  Logger.root.level = level;
  Logger.root.onRecord.listen((LogRecord record) {
    developer.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });
}

/// Logs informational messages.
void logInfo(Object message) {
  logger.info(message);
}

/// Logs warnings.
void logWarning(Object message) {
  logger.warning(message);
}

/// Logs errors or exceptions.
void logError(Object message, [Object? error, StackTrace? stackTrace]) {
  logger.severe(message, error, stackTrace);
}
