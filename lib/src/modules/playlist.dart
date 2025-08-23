import '../utils/request.dart';
import '../utils/module_registry.dart';

/// 歌单详情
Future<Map<String, dynamic>> playlistDetail(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(String, Map<String, dynamic>, RequestOptions) request,
) async {
  final data = {
    'id': query['id'],
    'n': '100000',
    's': '8',
  };

  return await request('/api/v6/playlist/detail', data, RequestOptions.create(query, crypto: 'api'));
}

/// 推荐歌单
Future<Map<String, dynamic>> personalized(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(String, Map<String, dynamic>, RequestOptions) request,
) async {
  final data = {
    'limit': query['limit'] ?? 30,
    'total': 'true',
    'n': '1000',
  };

  return await request('/api/personalized/playlist', data, RequestOptions.create(query, crypto: 'api'));
}

/// 每日推荐歌曲
Future<Map<String, dynamic>> recommendSongs(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(String, Map<String, dynamic>, RequestOptions) request,
) async {
  final data = <String, dynamic>{};

  return await request('/api/v3/discovery/recommend/songs', data, RequestOptions.create(query, crypto: 'weapi'));
}

/// 注册所有歌单相关模块
void registerPlaylistModules() {
  ModuleRegistry.register('playlistDetail', playlistDetail);
  ModuleRegistry.register('personalized', personalized);
  ModuleRegistry.register('recommendSongs', recommendSongs);
}
