/// 日志级别枚举
enum ApiLogLevel {
  debug,
  info,
  warning,
  error,
}

/// API日志输出接口
///
/// API库通过这个接口输出日志，具体的输出实现由使用者提供
abstract class ApiLogger {
  /// 输出日志
  ///
  /// [level] 日志级别
  /// [tag] 日志标签（如 [API], [CACHE], [HTTP] 等）
  /// [message] 日志消息
  /// [error] 错误对象（可选）
  /// [stackTrace] 堆栈跟踪（可选）
  void log(ApiLogLevel level, String tag, String message,
      [dynamic error, StackTrace? stackTrace]);
}

/// 默认的空日志实现
/// 什么都不输出，用于生产环境或不需要日志的场景
class SilentApiLogger implements ApiLogger {
  @override
  void log(ApiLogLevel level, String tag, String message,
      [dynamic error, StackTrace? stackTrace]) {
    // 不输出任何内容
  }
}

/// 简单的控制台日志实现
/// 使用 print 输出到控制台，保持API库的轻量化
class ConsoleApiLogger implements ApiLogger {
  final bool debugEnabled;

  const ConsoleApiLogger({this.debugEnabled = true});

  @override
  void log(ApiLogLevel level, String tag, String message,
      [dynamic error, StackTrace? stackTrace]) {
    // 在生产模式下，只输出警告和错误
    if (!debugEnabled &&
        (level == ApiLogLevel.debug || level == ApiLogLevel.info)) {
      return;
    }

    final levelStr = _getLevelString(level);
    final timestamp =
        DateTime.now().toString().substring(11, 23); // HH:mm:ss.mmm

    if (error != null) {
      print('[$timestamp] $levelStr $tag $message: $error');
      if (stackTrace != null) {
        print(stackTrace);
      }
    } else {
      print('[$timestamp] $levelStr $tag $message');
    }
  }

  String _getLevelString(ApiLogLevel level) {
    switch (level) {
      case ApiLogLevel.debug:
        return '[DEBUG]';
      case ApiLogLevel.info:
        return '[INFO]';
      case ApiLogLevel.warning:
        return '[WARN]';
      case ApiLogLevel.error:
        return '[ERROR]';
    }
  }
}

/// API日志管理器
///
/// API库内部使用这个类来输出日志
class ApiLogManager {
  static ApiLogger _logger = SilentApiLogger();

  /// 设置日志输出器
  static void setLogger(ApiLogger logger) {
    _logger = logger;
  }

  /// 获取当前日志输出器
  static ApiLogger get logger => _logger;

  // 便捷方法
  static void debug(String tag, String message,
      [dynamic error, StackTrace? stackTrace]) {
    _logger.log(ApiLogLevel.debug, tag, message, error, stackTrace);
  }

  static void info(String tag, String message,
      [dynamic error, StackTrace? stackTrace]) {
    _logger.log(ApiLogLevel.info, tag, message, error, stackTrace);
  }

  static void warning(String tag, String message,
      [dynamic error, StackTrace? stackTrace]) {
    _logger.log(ApiLogLevel.warning, tag, message, error, stackTrace);
  }

  static void error(String tag, String message,
      [dynamic error, StackTrace? stackTrace]) {
    _logger.log(ApiLogLevel.error, tag, message, error, stackTrace);
  }
}
