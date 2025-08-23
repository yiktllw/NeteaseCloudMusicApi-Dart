import 'dart:math';

class Utils {
  /// 转换为布尔值
  static bool toBoolean(dynamic val) {
    if (val is bool) return val;
    if (val == '') return false;
    return val == 'true' || val == '1';
  }

  /// Cookie字符串转JSON对象
  static Map<String, String> cookieToJson(String? cookie) {
    if (cookie == null || cookie.isEmpty) return {};
    
    final obj = <String, String>{};
    
    // 按分号分割，然后处理每个cookie项
    final cookieItems = cookie.split(';');
    
    for (final item in cookieItems) {
      final trimmedItem = item.trim();
      if (trimmedItem.isEmpty) continue;
      
      final equalIndex = trimmedItem.indexOf('=');
      if (equalIndex > 0) {
        final key = trimmedItem.substring(0, equalIndex).trim();
        final value = trimmedItem.substring(equalIndex + 1).trim();
        
        // 过滤掉浏览器cookie属性（以大写字母开头或特定属性）
        if (!_isCookieAttribute(key)) {
          obj[key] = value;
        }
      }
    }
    
    return obj;
  }

  /// 判断是否为cookie属性而非实际的cookie值
  static bool _isCookieAttribute(String key) {
    const attributes = {
      'Max-Age', 'Expires', 'Path', 'Domain', 'Secure', 'HttpOnly', 'SameSite'
    };
    return attributes.contains(key);
  }

  /// Cookie对象转字符串
  static String cookieObjToString(Map<String, String> cookie) {
    return cookie.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('; ');
  }

  /// 生成随机数
  static int getRandom(int num) {
    final random = Random();
    final base = (random.nextDouble() + random.nextInt(9) + 1) * pow(10, num - 1);
    return base.floor();
  }

  /// 生成随机中国IP
  static String generateRandomChineseIP() {
    const chinaIPPrefixes = ['116.25', '116.76', '116.77', '116.78'];
    final random = Random();
    
    final randomPrefix = chinaIPPrefixes[random.nextInt(chinaIPPrefixes.length)];
    return '$randomPrefix.${_generateIPSegment()}.${_generateIPSegment()}';
  }

  /// 生成IP段
  static int _generateIPSegment() {
    return Random().nextInt(255) + 1;
  }

  /// 生成随机字符串
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    final random = Random();
    final buffer = StringBuffer();
    
    for (int i = 0; i < length; i++) {
      buffer.write(chars[random.nextInt(chars.length)]);
    }
    
    return buffer.toString();
  }

  /// 生成设备ID
  static String generateDeviceId() {
    final randomString = generateRandomString(6);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$randomString.$timestamp.01.0';
  }
}
