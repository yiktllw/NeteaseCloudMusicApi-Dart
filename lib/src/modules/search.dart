import '../utils/request.dart';

/// 搜索
Future<Map<String, dynamic>> search(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  if (query['type'] != null && query['type'] == '2000') {
    final data = {
      'keyword': query['keywords'],
      'scene': 'normal',
      'limit': query['limit'] ?? 30,
      'offset': query['offset'] ?? 0,
    };
    return await request(
        '/api/search/voice/get', data, RequestOptions.create(query));
  }

  final data = {
    's': query['keywords'],
    'type': query['type'] ??
        1, // 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
    'limit': query['limit'] ?? 30,
    'offset': query['offset'] ?? 0,
  };

  return await request('/api/search/get', data, RequestOptions.create(query));
}
