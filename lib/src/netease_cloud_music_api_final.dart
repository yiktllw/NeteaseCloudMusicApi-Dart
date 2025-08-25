import 'utils/request.dart';
import 'utils/utils.dart';
import 'utils/module_registry.dart';
import 'utils/auto_register.dart';
import 'utils/api_constants.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// 网易云音乐API核心类 - 最终简化版本
class NeteaseCloudMusicApiFinal {
  late String _anonymousToken;
  late String _deviceId;
  late String _cnIp;
  bool _initialized = false;
  
  /// 是否启用API请求日志输出
  static bool enableApiLogging = true;

  /// 构造函数
  NeteaseCloudMusicApiFinal();

  /// 确保初始化完成
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }

  /// 初始化
  Future<void> init() async {
    // 注册所有模块
    AutoRegister.registerAllModules();
    
    _cnIp = Utils.generateRandomChineseIP();
    _deviceId = Utils.generateDeviceId();
    
    // 设置全局变量
    RequestHelper.globalCnIp = _cnIp;
    RequestHelper.globalDeviceId = _deviceId;
    
    _initialized = true;
    
    try {
      final result = await registerAnonymous();
      final cookie = result['body']['cookie'];
      if (cookie != null) {
        final cookieObj = Utils.cookieToJson(cookie);
        _anonymousToken = cookieObj['MUSIC_A'] ?? '';
        RequestHelper.anonymousToken = _anonymousToken;
      }
    } catch (error) {
      print('初始化失败: $error');
      _anonymousToken = '';
    }
  }

  /// 匿名注册
  Future<Map<String, dynamic>> registerAnonymous() async {
    final deviceIds = [
      'AA9955F5FE37BA7EAF48F8EF0C9966B28293CC8D6415CCD93549',
      'C4BE5BA8E337E26A1ECA938DAF7DDC6D99AA353D9E2E69F5DE2A',
      '2A6626990ED0B095ADBF14D63D91C6F8AE4CF352FF9BD1FE724E',
      '184117F946D9CF013300B74BAAFF42C04B74CE59EDA3A7B31C8E',
      '7051B0BEB96D5DC0DA8C17A034008DE086A21AB833EA41D321FF',
    ];
    final deviceId = deviceIds[DateTime.now().millisecond % deviceIds.length];
    final encodedId = _generateEncodedId(deviceId);
    
    final data = <String, dynamic>{
      'username': encodedId,
    };
    
    return await _request('/api/register/anonimous', data, RequestOptions(crypto: 'weapi'));
  }

  /// 生成编码ID
  String _generateEncodedId(String deviceId) {
    const idXorKey = '3go8&\$8*3*3h0k(2)2';
    
    String xoredString = '';
    for (int i = 0; i < deviceId.length; i++) {
      final charCode = deviceId.codeUnitAt(i) ^ idXorKey.codeUnitAt(i % idXorKey.length);
      xoredString += String.fromCharCode(charCode);
    }
    
    final bytes = utf8.encode(xoredString);
    final digest = md5.convert(bytes);
    final hashedBase64 = base64.encode(digest.bytes);
    
    final finalString = '$deviceId $hashedBase64';
    return base64.encode(utf8.encode(finalString));
  }

  /// 通用模块调用方法 - 极简版本
  Future<Map<String, dynamic>> call(String moduleName, Map<String, dynamic> params) async {
    await _ensureInitialized();
    
    // 构建请求路径用于日志
    String logPath = '/$moduleName';
    if (params.isNotEmpty) {
      final paramsList = params.entries
          .where((e) => e.key != 'cookie') // 不在日志中显示敏感信息
          .map((e) => '${e.key}=${e.value}')
          .toList();
      if (paramsList.isNotEmpty) {
        logPath += '?${paramsList.join('&')}';
      }
    }
    
    try {
      final result = await ModuleRegistry.call(moduleName, params, _request);
      
      // 记录成功日志
      if (enableApiLogging) {
        print('[SUCCESS] $logPath');
      }
      
      return result;
    } catch (e) {
      // 记录错误日志
      if (enableApiLogging) {
        print('[ERROR] $logPath - $e');
      }
      rethrow;
    }
  }

  /// 设置API日志开关
  static void setApiLogging(bool enabled) {
    enableApiLogging = enabled;
  }

  /// 获取当前API日志开关状态
  static bool getApiLogging() {
    return enableApiLogging;
  }

  /// 类型安全的API调用器 - 提供完整的IDE支持
  /// 
  /// 使用方式：
  /// ```dart
  /// // 有完整参数提示和类型检查
  /// await api.api.playlistDetail(id: '123', s: '8');
  /// await api.api.search(keywords: '周杰伦', type: 1, limit: 50);
  /// await api.api.userDetail(uid: '12345');
  /// ```
  ApiCaller get api => ApiCaller(call);

  /// 私有请求方法
  Future<Map<String, dynamic>> _request(
    String uri,
    Map<String, dynamic> data,
    RequestOptions options,
  ) async {
    final ip = options.ip ?? _cnIp;
    final newOptions = RequestOptions(
      crypto: options.crypto,
      cookie: options.cookie,
      ua: options.ua,
      proxy: options.proxy,
      realIP: options.realIP,
      ip: ip,
      eR: options.eR,
      headers: options.headers,
    );

    return await RequestHelper.createRequest(uri, data, newOptions);
  }

  /// 调试方法：列出所有可用的模块
  List<String> getAvailableModules() {
    return ModuleRegistry.getAllModuleNames();
  }

  // 调试和统计方法
  int getRegisteredModuleCount() => ModuleRegistry.getAllModules().length;
  
  List<String> getRegisteredModuleNames() => ModuleRegistry.getAllModules().keys.toList();
}
