import 'package:logging/logging.dart';

/// Extension methods on Logger to make logging more convenient
extension LoggerExtensions on Logger {
  void v(String message, [Object? error, StackTrace? stackTrace]) {
    finest(message, error, stackTrace);
  }

  void d(String message, [Object? error, StackTrace? stackTrace]) {
    fine(message, error, stackTrace);
  }

  void i(String message, [Object? error, StackTrace? stackTrace]) {
    info(message, error, stackTrace);
  }

  void w(String message, [Object? error, StackTrace? stackTrace]) {
    warning(message, error, stackTrace);
  }

  void e(String message, [Object? error, StackTrace? stackTrace]) {
    severe(message, error, stackTrace);
  }

  void wtf(String message, [Object? error, StackTrace? stackTrace]) {
    shout(message, error, stackTrace);
  }

  /// Group related logs under a common heading
  void group(String groupName, void Function() logFunction) {
    info('┌── BEGIN: $groupName ───────────────');
    try {
      logFunction();
    } finally {
      info('└── END: $groupName ─────────────────');
    }
  }

  /// Log method entry with parameters
  void enter(String methodName, [Map<String, dynamic>? params]) {
    if (isLoggable(Level.FINE)) {
      String message = '➡️ Entering $methodName';
      if (params != null && params.isNotEmpty) {
        message += ' with params: $params';
      }
      fine(message);
    }
  }

  /// Log method exit with optional return value
  void exit(String methodName, [dynamic returnValue]) {
    if (isLoggable(Level.FINE)) {
      String message = '⬅️ Exiting $methodName';
      if (returnValue != null) {
        message += ' with result: $returnValue';
      }
      fine(message);
    }
  }
}
