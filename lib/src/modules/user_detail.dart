import '../utils/request.dart';
import '../utils/module_registry.dart';

/// 用户详情
Future<Map<String, dynamic>> userDetail(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(String, Map<String, dynamic>, RequestOptions) request,
) async {
  final data = <String, dynamic>{};
  final response = await request('/api/v1/user/detail/${query['uid']}', data, RequestOptions.create(query, crypto: 'api'));
  return response;
}

/// 注册模块到注册表
void registerUserDetailModule() {
  ModuleRegistry.register('userDetail', userDetail);
}
