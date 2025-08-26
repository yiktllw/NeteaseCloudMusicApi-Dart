import 'dart:convert';
import 'dart:async';
import 'dart:developer' as dev;
import 'memory_cache.dart';

/// API缓存，对应原项目的 apicache.js
class ApiCache {
  final MemoryCache _memCache = MemoryCache();

  final Map<String, dynamic> _globalOptions = {
    'debug': true, // 启用调试日志
    'defaultDuration': 3600000, // 1小时，但会被具体配置覆盖
    'enabled': true,
    'headerBlacklist': <String>[],
    'statusCodes': {
      'include': <int>[],
      'exclude': <int>[],
    },
    'headers': <String, String>{},
    'trackPerformance': false,
  };

  final Map<String, dynamic> _index = {
    'all': <String>[],
    'groups': <String, List<String>>{},
  };

  final Map<String, Timer> _timers = {};

  /// 调试日志
  void _debug(String message) {
    if (_globalOptions['debug'] == true) {
      dev.log('[apicache] $message');
    }
  }

  /// 判断是否应该缓存响应
  bool _shouldCacheResponse(
      Map<String, dynamic> request,
      Map<String, dynamic> response,
      bool Function(Map<String, dynamic>, Map<String, dynamic>)? toggle) {
    final statusCodes = _globalOptions['statusCodes'] as Map<String, dynamic>;
    final include = statusCodes['include'] as List<int>;
    final exclude = statusCodes['exclude'] as List<int>;

    if (toggle != null && !toggle(request, response)) {
      return false;
    }

    final statusCode = response['status'] as int;

    if (exclude.isNotEmpty && exclude.contains(statusCode)) {
      return false;
    }

    if (include.isNotEmpty && !include.contains(statusCode)) {
      return false;
    }

    return true;
  }

  /// 创建缓存对象
  Map<String, dynamic> _createCacheObject(
      int status, Map<String, String> headers, dynamic data) {
    return {
      'status': status,
      'headers': headers,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch / 1000,
    };
  }

  /// 缓存响应
  void _cacheResponse(String key, Map<String, dynamic> value, int duration) {
    _memCache.add(key, value, duration);

    // 添加到索引
    final all = _index['all'] as List<String>;
    all.insert(0, key);

    // 设置自动清理定时器
    _timers[key] = Timer(Duration(milliseconds: duration), () {
      clear(key, true);
    });
  }

  /// 解析持续时间
  int _parseDuration(dynamic duration, int defaultDuration) {
    if (duration is int) return duration;

    if (duration is String) {
      // 简化的解析，支持 "2 minutes" 格式
      final match = RegExp(r'^(\d+)\s*(\w+)$').firstMatch(duration);
      if (match != null) {
        final value = int.tryParse(match.group(1)!) ?? 1;
        final unit = match.group(2)!.toLowerCase();

        switch (unit) {
          case 'ms':
          case 'milliseconds':
            return value;
          case 's':
          case 'second':
          case 'seconds':
            return value * 1000;
          case 'm':
          case 'minute':
          case 'minutes':
            return value * 60000;
          case 'h':
          case 'hour':
          case 'hours':
            return value * 3600000;
          case 'd':
          case 'day':
          case 'days':
            return value * 86400000;
        }
      }
    }

    return defaultDuration;
  }

  /// 中间件方法，对应原项目的 cache('2 minutes', toggle)
  Future<Map<String, dynamic>> middleware(
    String duration,
    bool Function(Map<String, dynamic>, Map<String, dynamic>)? toggle,
    Future<Map<String, dynamic>> Function() next,
    Map<String, dynamic> request,
  ) async {
    final durationMs =
        _parseDuration(duration, _globalOptions['defaultDuration'] as int);

    if (_globalOptions['enabled'] != true) {
      _debug('bypass detected, skipping cache.');
      return await next();
    }

    // 生成缓存键，对应原项目的 hostname + url + cookies
    final key = _generateKey(request);

    // 尝试获取缓存
    final cached = _memCache.getValue(key);
    if (cached != null) {
      _debug('sending cached version of $key');
      // 从缓存对象中提取实际的数据
      final cacheObject = cached as Map<String, dynamic>;
      final cachedResult = Map<String, dynamic>.from(
          cacheObject['data'] as Map<String, dynamic>);
      cachedResult['_fromCache'] = true; // 添加缓存标识
      return cachedResult;
    }

    // 缓存未命中，执行请求
    _debug('cache miss for $key');
    final result = await next();
    result['_fromCache'] = false; // 标识非缓存结果

    // 缓存响应（只缓存状态码200的响应）
    if (_shouldCacheResponse(request, result, toggle)) {
      final cacheObject = _createCacheObject(
        result['status'] as int,
        result['headers'] as Map<String, String>? ?? {},
        result,
      );
      _cacheResponse(key, cacheObject, durationMs);
      _debug('cached response for $key');
    }

    return result;
  }

  /// 生成缓存键
  String _generateKey(Map<String, dynamic> request) {
    final hostname = request['hostname'] ?? 'localhost';
    final url = request['url'] ?? '';
    final cookies = request['cookies'] ?? {};

    // 构建缓存键 - URL中已经包含了timestamp信息
    String baseKey = hostname + url + jsonEncode(cookies);

    return baseKey;
  }

  /// 清除缓存
  void clear([String? target, bool isAutomatic = false]) {
    if (target == null) {
      _debug('clearing entire index');
      _memCache.clear();
      for (final timer in _timers.values) {
        timer.cancel();
      }
      _timers.clear();
      (_index['all'] as List<String>).clear();
      (_index['groups'] as Map<String, List<String>>).clear();
      return;
    }

    _debug(
        'clearing ${isAutomatic ? "expired" : "cached"} entry for "$target"');

    final timer = _timers[target];
    timer?.cancel();
    _timers.remove(target);

    _memCache.delete(target);

    final all = _index['all'] as List<String>;
    all.remove(target);
  }

  /// 获取缓存索引
  Map<String, dynamic> getIndex([String? group]) {
    if (group != null) {
      final groups = _index['groups'] as Map<String, List<String>>;
      return {'group': group, 'keys': groups[group] ?? []};
    }
    return _index;
  }
}

/// 全局API缓存实例
final apiCache = ApiCache();
