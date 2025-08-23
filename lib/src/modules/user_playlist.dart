import '../utils/request.dart';
import '../utils/module_registry.dart';

/// 用户歌单
Future<Map<String, dynamic>> userPlaylist(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(String, Map<String, dynamic>, RequestOptions) request,
) async {
  final data = {
    'uid': query['uid'],
    'limit': query['limit'] ?? 30,
    'offset': query['offset'] ?? 0,
    'includeVideo': true,
  };

  return await request('/api/user/playlist', data, RequestOptions.create(query, crypto: 'weapi'));
}

/// 注册用户歌单模块
void registerUserPlaylistModule() {
  ModuleRegistry.register('userPlaylist', userPlaylist);
}
