import 'package:logging/logging.dart';
import 'app_logger.dart';

/// Helper class to create module-specific loggers
class LogModule {
  final String _moduleName;

  LogModule(this._moduleName);

  Logger get network => AppLogger().getLogger('$_moduleName.network');
  Logger get ui => AppLogger().getLogger('$_moduleName.ui');
  Logger get state => AppLogger().getLogger('$_moduleName.state');
  Logger get db => AppLogger().getLogger('$_moduleName.database');
  Logger get analytics => AppLogger().getLogger('$_moduleName.analytics');
  Logger get performance => AppLogger().getLogger('$_moduleName.performance');

  /// Get a custom submodule logger
  Logger submodule(String name) => AppLogger().getLogger('$_moduleName.$name');
}
