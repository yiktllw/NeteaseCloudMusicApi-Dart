import '../utils/request.dart';
import '../utils/module_registry.dart';

/// 用户听歌记录
Future<Map<String, dynamic>> userRecord(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = {
    'uid': query['uid'],
    'type': query['type'] ?? 0, // 1: 最近一周, 0: 所有时间
  };

  return await request('/api/v1/play/record', data,
      RequestOptions.create(query, crypto: 'weapi'));
}

/// 注册用户听歌记录模块
void registerUserRecordModule() {
  ModuleRegistry.register('userRecord', userRecord);
}
