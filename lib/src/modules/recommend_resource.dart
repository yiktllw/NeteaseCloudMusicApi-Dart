import '../utils/request.dart';

/// 每日推荐歌单
Future<Map<String, dynamic>> recommendResource(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  return await request(
    '/api/v1/discovery/recommend/resource',
    <String, dynamic>{},
    RequestOptions.create(query, crypto: 'weapi'),
  );
}
