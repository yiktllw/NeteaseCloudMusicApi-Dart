import '../utils/request.dart';
import '../utils/module_registry.dart';

/// 用户账户信息
///
/// 获取当前登录用户的账户详细信息，包括账户状态、会员信息等
Future<Map<String, dynamic>> userAccount(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = <String, dynamic>{};
  return await request('/api/nuser/account/get', data,
      RequestOptions.create(query, crypto: 'weapi'));
}

/// 注册模块到注册表
void registerUserAccountModule() {
  ModuleRegistry.register('userAccount', userAccount);
}
