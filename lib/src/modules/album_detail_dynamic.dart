import '../utils/request.dart';

/// 专辑动态信息
///
/// [query] 查询参数
/// - id: 专辑 ID (必需)
///
/// 返回专辑的动态信息，如播放量、评论数、分享数等
Future<Map<String, dynamic>> albumDetailDynamic(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final id = query['id'];
  if (id == null) {
    throw ArgumentError('Missing required parameter: id');
  }

  final data = {
    'id': id,
  };

  return await request('/api/album/detail/dynamic', data,
      RequestOptions.create(query, crypto: 'weapi'));
}
