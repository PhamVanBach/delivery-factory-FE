import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

/// A utility class that wraps the logging package functionality.
/// Provides easy access to different log levels and customized formatting.
class AppLogger {
  /// Singleton instance
  static final AppLogger _instance = AppLogger._internal();

  /// Factory constructor to return the singleton instance
  factory AppLogger() => _instance;

  /// Private constructor
  AppLogger._internal() {
    _initializeLogging();
  }

  /// Initialize logging configuration with colored output and levels
  void _initializeLogging() {
    // Set up the root logger
    Logger.root.level = kReleaseMode ? Level.INFO : Level.ALL;

    // Set up log listener
    Logger.root.onRecord.listen((record) {
      // Don't log in release mode if level is below INFO
      if (kReleaseMode && record.level.value < Level.INFO.value) {
        return;
      }

      // Format the log message with color, time, level, and logger name
      String emoji = _getEmojiForLevel(record.level);
      String color = _getColorForLevel(record.level);
      String resetColor = '\x1B[0m';

      String timeStr =
          "${record.time.hour.toString().padLeft(2, '0')}:${record.time.minute.toString().padLeft(2, '0')}:${record.time.second.toString().padLeft(2, '0')}";

      debugPrint(
        '$color$emoji [${record.level.name}] [$timeStr] [${record.loggerName}] ${record.message}$resetColor',
      );

      // Print stack trace if available
      if (record.error != null) {
        debugPrint('$color${record.error}$resetColor');
      }

      if (record.stackTrace != null) {
        debugPrint('$color${record.stackTrace}$resetColor');
      }
    });
  }

  /// Get emoji indicator for log level
  String _getEmojiForLevel(Level level) {
    if (level == Level.FINEST) return '🔍';
    if (level == Level.FINER) return '🔎';
    if (level == Level.FINE) return '🔬';
    if (level == Level.CONFIG) return '⚙️';
    if (level == Level.INFO) return 'ℹ️';
    if (level == Level.WARNING) return '⚠️';
    if (level == Level.SEVERE) return '🔥';
    if (level == Level.SHOUT) return '‼️';
    return '📝';
  }

  /// Get ANSI color code for log level
  String _getColorForLevel(Level level) {
    if (level == Level.FINEST || level == Level.FINER || level == Level.FINE)
      return '\x1B[90m'; // Gray
    if (level == Level.CONFIG) return '\x1B[36m'; // Cyan
    if (level == Level.INFO) return '\x1B[32m'; // Green
    if (level == Level.WARNING) return '\x1B[33m'; // Yellow
    if (level == Level.SEVERE) return '\x1B[31m'; // Red
    if (level == Level.SHOUT) return '\x1B[35m'; // Purple
    return '\x1B[0m'; // Reset
  }

  /// Creates or retrieves a logger for the specified name
  Logger getLogger(String name) {
    return Logger(name);
  }

  /// Convenience method to get a logger based on the class name
  Logger getLoggerForClass(Type type) {
    return getLogger(type.toString());
  }
}
