import '../utils/request.dart';

/// 每日推荐歌曲
Future<Map<String, dynamic>> recommendSongs(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = <String, dynamic>{};

  return await request('/api/v3/discovery/recommend/songs', data,
      RequestOptions.create(query, crypto: 'weapi'));
}
