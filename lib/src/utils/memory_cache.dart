import 'dart:async';

/// 内存缓存，对应原项目的 memory-cache.js
class MemoryCache {
  final Map<String, _CacheEntry> _cache = {};

  int get size => _cache.length;

  /// 添加缓存
  _CacheEntry? add(String key, dynamic value, int time,
      [Function(dynamic, String)? timeoutCallback]) {
    final old = _cache[key];
    old?.timeout?.cancel();

    final entry = _CacheEntry(
      value: value,
      expire: DateTime.now().millisecondsSinceEpoch + time,
      timeout: Timer(Duration(milliseconds: time), () {
        delete(key);
        timeoutCallback?.call(value, key);
      }),
    );

    _cache[key] = entry;
    return entry;
  }

  /// 删除缓存
  void delete(String key) {
    final entry = _cache[key];
    if (entry != null) {
      entry.timeout?.cancel();
    }
    _cache.remove(key);
  }

  /// 获取缓存条目
  _CacheEntry? get(String key) {
    final entry = _cache[key];
    if (entry != null && DateTime.now().millisecondsSinceEpoch > entry.expire) {
      delete(key);
      return null;
    }
    return entry;
  }

  /// 获取缓存值
  dynamic getValue(String key) {
    final entry = get(key);
    return entry?.value;
  }

  /// 清空缓存
  void clear() {
    for (final key in _cache.keys.toList()) {
      delete(key);
    }
  }
}

class _CacheEntry {
  final dynamic value;
  final int expire;
  final Timer? timeout;

  _CacheEntry({
    required this.value,
    required this.expire,
    this.timeout,
  });
}
