import '../utils/request.dart';

/// 推荐歌单
Future<Map<String, dynamic>> personalized(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = {
    'limit': query['limit'] ?? 30,
    'total': true,
    'n': 1000,
  };

  return await request('/api/personalized/playlist', data,
      RequestOptions.create(query, crypto: 'weapi'));
}
