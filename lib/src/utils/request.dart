import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'crypto.dart';
import 'utils.dart';
import 'apicache.dart';

class RequestHelper {
  static const Map<String, Map<String, String>> osMap = {
    'pc': {
      'os': 'pc',
      'appver': '3.0.18.203152',
      'osver': 'Microsoft-Windows-10-Professional-build-22631-64bit',
      'channel': 'netease',
    },
    'linux': {
      'os': 'linux',
      'appver': '1.2.1.0428',
      'osver': 'Deepin 20.9',
      'channel': 'netease',
    },
    'android': {
      'os': 'android',
      'appver': '8.20.20.231215173437',
      'osver': '14',
      'channel': 'xiaomi',
    },
    'iphone': {
      'os': 'iOS',
      'appver': '9.0.90',
      'osver': '16.2',
      'channel': 'distribution',
    },
  };

  static const Map<String, Map<String, String>> userAgentMap = {
    'weapi': {
      'pc': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0',
    },
    'linuxapi': {
      'linux': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36',
    },
    'api': {
      'pc': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36 Chrome/91.0.4472.164 NeteaseMusicDesktop/3.0.18.203152',
      'android': 'NeteaseMusic/9.1.65.240927161425(9001065);Dalvik/2.1.0 (Linux; U; Android 14; 23013RK75C Build/UKQ1.230804.001)',
      'iphone': 'NeteaseMusic 9.0.90/5038 (iPhone; iOS 16.2; zh_CN)',
    },
  };

  static const String domain = 'https://music.163.com';
  static const String apiDomain = 'https://interface.music.163.com';
  
  static String? anonymousToken = ''; // 初始化为空字符串，与原项目保持一致
  static String? globalDeviceId;
  static String? globalCnIp;

  /// 选择User-Agent
  static String chooseUserAgent(String crypto, {String uaType = 'pc'}) {
    return userAgentMap[crypto]?[uaType] ?? '';
  }

  /// 创建请求（带2分钟缓存，对应原项目配置）
  static Future<Map<String, dynamic>> createRequest(
    String uri,
    Map<String, dynamic> data,
    RequestOptions options,
  ) async {
    // 提取timestamp参数用于缓存区分，但不发送给服务器
    final timestamp = data['timestamp'];
    final actualData = Map<String, dynamic>.from(data);
    actualData.remove('timestamp'); // 从实际请求数据中移除timestamp
    
    // 构建请求信息，用于缓存键生成
    // 如果有timestamp，将其包含在URL中以影响缓存键
    String urlForCache = uri + jsonEncode(actualData);
    if (timestamp != null) {
      urlForCache += '_ts_$timestamp';
    }
    
    final requestInfo = {
      'hostname': uri.startsWith('/weapi/') ? 'music.163.com' : 'interface.music.163.com',
      'url': urlForCache,
      'cookies': options.cookie ?? {},
    };

    // 使用缓存中间件，对应原项目的 cache('2 minutes', toggle)
    return await apiCache.middleware(
      '2 minutes',
      (_, response) => response['status'] == 200, // 只缓存状态码200的响应
      () => _executeRequest(uri, actualData, options), // 使用不包含timestamp的数据
      requestInfo,
    );
  }

  /// 执行实际的HTTP请求
  static Future<Map<String, dynamic>> _executeRequest(
    String uri,
    Map<String, dynamic> data,
    RequestOptions options,
  ) async {
    print('[REQUEST] 开始执行请求: $uri');
    print('[REQUEST] 请求参数: $data');
    
    final headers = <String, String>{
      ...?options.headers,
    };

    // 设置IP头
    final ip = options.realIP ?? options.ip ?? '';
    if (ip.isNotEmpty) {
      headers['X-Real-IP'] = ip;
      headers['X-Forwarded-For'] = ip;
    }

    // 处理Cookie
    var cookie = options.cookie ?? <String, String>{};
    
    // 如果cookie是字符串，先转换为Map
    if (cookie is String) {
      cookie = Utils.cookieToJson(cookie);
    }

    if (cookie is Map<String, String>) {
      final nuid = _generateRandomString(32);
      final os = osMap[cookie['os']] ?? osMap['iphone']!;
      
      // 完全按照原JS项目的逻辑：先复制原cookie，然后用默认值填充缺失项
      final originalCookie = Map<String, String>.from(cookie);
      cookie = {
        ...originalCookie,
        '__remember_me': originalCookie['__remember_me'] ?? 'true',
        'ntes_kaola_ad': originalCookie['ntes_kaola_ad'] ?? '1',
        '_ntes_nuid': originalCookie['_ntes_nuid'] ?? nuid,
        '_ntes_nnid': originalCookie['_ntes_nnid'] ?? '$nuid,${DateTime.now().millisecondsSinceEpoch}',
        'WNMCID': originalCookie['WNMCID'] ?? Utils.generateDeviceId(),
        'WEVNSM': originalCookie['WEVNSM'] ?? '1.0.0',
        'osver': originalCookie['osver'] ?? os['osver']!,
        'deviceId': originalCookie['deviceId'] ?? globalDeviceId ?? '',
        'os': originalCookie['os'] ?? os['os']!,
        'channel': originalCookie['channel'] ?? os['channel']!,
        'appver': originalCookie['appver'] ?? os['appver']!,
      };

      if (!uri.contains('login')) {
        cookie['NMTID'] = _generateRandomString(16);
      }

      if (cookie['MUSIC_U'] == null || cookie['MUSIC_U']!.isEmpty) {
        // 游客用户
        cookie['MUSIC_A'] = cookie['MUSIC_A'] ?? anonymousToken ?? '';
      }

      headers['Cookie'] = Utils.cookieObjToString(cookie);
    }

    String url = '';
    Map<String, String> encryptData = {};
    String crypto = options.crypto;
    final csrfToken = cookie['__csrf'] ?? '';

    if (crypto.isEmpty) {
      crypto = 'api'; // 默认使用api
    }

    // 根据加密方式处理数据
    switch (crypto) {
      case 'weapi':
        headers['Referer'] = domain;
        headers['User-Agent'] = options.ua ?? chooseUserAgent('weapi');
        // 对于weapi，使用处理过的cookie（不再覆盖Cookie头）
        data['csrf_token'] = csrfToken;
        encryptData = CryptoHelper.weapi(data);
        url = '$domain/weapi/${uri.substring(5)}';
        break;

      case 'linuxapi':
        headers['User-Agent'] = options.ua ?? chooseUserAgent('linuxapi', uaType: 'linux');
        encryptData = CryptoHelper.linuxapi({
          'method': 'POST',
          'url': '$domain$uri',
          'params': data,
        });
        url = '$domain/api/linux/forward';
        break;

      case 'eapi':
      case 'api':
        // 对于eapi和api，重新构造header对象作为Cookie
        final header = {
          'osver': cookie['osver'] ?? '',
          'deviceId': cookie['deviceId'] ?? '',
          'os': cookie['os'] ?? '',
          'appver': cookie['appver'] ?? '',
          'versioncode': cookie['versioncode'] ?? '140',
          'mobilename': cookie['mobilename'] ?? '',
          'buildver': cookie['buildver'] ?? (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
          'resolution': cookie['resolution'] ?? '1920x1080',
          '__csrf': csrfToken,
          'channel': cookie['channel'] ?? '',
          'requestId': '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000).toString().padLeft(4, '0')}',
        };

        if (cookie['MUSIC_U']?.isNotEmpty == true) header['MUSIC_U'] = cookie['MUSIC_U']!;
        if (cookie['MUSIC_A']?.isNotEmpty == true) header['MUSIC_A'] = cookie['MUSIC_A']!;

        // 重新设置Cookie头，覆盖之前的设置
        headers['Cookie'] = header.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; ');
        headers['User-Agent'] = options.ua ?? chooseUserAgent('api', uaType: 'iphone');

        if (crypto == 'eapi') {
          data['header'] = header;
          data['e_r'] = options.eR ?? false;
          encryptData = CryptoHelper.eapi(uri, data);
          url = '$apiDomain/eapi/${uri.substring(5)}';
        } else {
          url = '$apiDomain$uri';
          encryptData = data.map((key, value) => MapEntry(key, value.toString()));
        }
        break;

      default:
        throw Exception('Unknown crypto: $crypto');
    }

    // 发送HTTP请求
    return await _sendHttpRequest(url, encryptData, headers, options);
  }

  /// 发送HTTP请求
  static Future<Map<String, dynamic>> _sendHttpRequest(
    String url,
    Map<String, String> data,
    Map<String, String> headers,
    RequestOptions options,
  ) async {
    try {
      print('[HTTP] 正在发送HTTP请求到: $url');
      print('[HTTP] 请求数据: $data');
      
      final client = HttpClient();
      final uri = Uri.parse(url);
      final request = await client.postUrl(uri);

      // 设置请求头
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');

      // 设置请求体
      final body = data.entries
          .map((entry) => '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}')
          .join('&');
      request.write(body);

      print('[HTTP] 发送请求中...');
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      print('[HTTP] 收到响应，状态码: ${response.statusCode}');

      final cookies = response.headers['set-cookie']
          ?.map((cookie) => cookie.replaceAll(RegExp(r'\s*Domain=[^(;|$)]+;*'), ''))
          .toList() ?? [];

      Map<String, dynamic> responseData;
      try {
        if (options.eR == true) {
          // EAPI解密
          responseData = CryptoHelper.eapiResDecrypt(responseBody.toUpperCase());
        } else {
          responseData = jsonDecode(responseBody);
        }
      } catch (e) {
        responseData = {'data': responseBody};
      }

      if (responseData['code'] != null) {
        responseData['code'] = int.tryParse(responseData['code'].toString()) ?? responseData['code'];
      }

      final status = responseData['code'] ?? response.statusCode;
      final finalStatus = [201, 302, 400, 502, 800, 801, 802, 803].contains(status) ? 200 : status;

      client.close();

      return {
        'status': finalStatus,
        'body': responseData,
        'cookie': cookies,
      };
    } catch (e) {
      return {
        'status': 502,
        'body': {'code': 502, 'msg': e.toString()},
        'cookie': <String>[],
      };
    }
  }

  /// 生成随机字符串
  static String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final buffer = StringBuffer();
    
    for (int i = 0; i < length; i++) {
      buffer.write(chars[random.nextInt(chars.length)]);
    }
    
    return buffer.toString();
  }
}

/// 请求选项类
class RequestOptions {
  final String crypto;
  final dynamic cookie;
  final String? ua;
  final String? proxy;
  final String? realIP;
  final String? ip;
  final bool? eR;
  final Map<String, String>? headers;

  RequestOptions({
    this.crypto = '',
    this.cookie,
    this.ua,
    this.proxy,
    this.realIP,
    this.ip,
    this.eR,
    this.headers,
  });

  factory RequestOptions.create(Map<String, dynamic> query, {String crypto = ''}) {
    return RequestOptions(
      crypto: query['crypto'] ?? crypto,
      cookie: query['cookie'],
      ua: query['ua'],
      proxy: query['proxy'],
      realIP: query['realIP'],
      ip: query['ip'],
      eR: query['e_r'],
    );
  }
}
