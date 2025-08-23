import '../utils/request.dart';

/// API模块的统一接口
typedef ApiModule = Future<Map<String, dynamic>> Function(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(String, Map<String, dynamic>, RequestOptions) request,
);

/// 模块注册表
class ModuleRegistry {
  static final Map<String, ApiModule> _modules = {};

  /// 注册模块
  static void register(String name, ApiModule module) {
    _modules[name] = module;
  }

  /// 获取模块
  static ApiModule? get(String name) {
    return _modules[name];
  }

  /// 调用模块
  static Future<Map<String, dynamic>> call(
    String name,
    Map<String, dynamic> query,
    Future<Map<String, dynamic>> Function(String, Map<String, dynamic>, RequestOptions) request,
  ) async {
    final module = _modules[name];
    if (module == null) {
      throw Exception('Module $name not found');
    }
    return await module(query, request);
  }

  /// 获取所有已注册的模块名称
  static List<String> getAllModuleNames() {
    return _modules.keys.toList();
  }

  /// 获取所有已注册的模块
  static Map<String, ApiModule> getAllModules() {
    return Map.from(_modules);
  }
}
