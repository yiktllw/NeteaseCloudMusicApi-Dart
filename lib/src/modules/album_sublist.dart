import '../utils/request.dart';

/// 已收藏专辑列表
///
/// [query] 查询参数
/// - limit: 返回数量限制，默认为 25
/// - offset: 偏移量，默认为 0
///
/// 返回用户已收藏的专辑列表
Future<Map<String, dynamic>> albumSublist(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = {
    'limit': query['limit'] ?? 25,
    'offset': query['offset'] ?? 0,
    'total': true,
  };

  return await request('/api/album/sublist', data,
      RequestOptions.create(query, crypto: 'weapi'));
}
