import '../utils/request.dart';
import '../utils/module_registry.dart';

/// 登录刷新
Future<Map<String, dynamic>> loginRefresh(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final result = await request(
    '/api/login/token/refresh',
    <String, dynamic>{},
    RequestOptions.create(query),
  );

  if (result['body']['code'] == 200) {
    return {
      'status': 200,
      'body': <String, dynamic>{
        ...result['body'] as Map<String, dynamic>,
        'cookie': (result['cookie'] as List).join(';'),
      },
      'cookie': result['cookie'],
    };
  }

  return result;
}

/// 注册登录刷新模块
void registerLoginRefreshModule() {
  ModuleRegistry.register('loginRefresh', loginRefresh);
}
