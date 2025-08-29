import '../utils/request.dart';

/// 专辑内容
///
/// [query] 查询参数
/// - id: 专辑 ID (必需)
///
/// 返回专辑详细信息，包括歌曲列表、专辑信息等
Future<Map<String, dynamic>> album(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final id = query['id'];
  if (id == null) {
    throw ArgumentError('Missing required parameter: id');
  }

  return await request('/api/v1/album/$id', {},
      RequestOptions.create(query, crypto: 'weapi'));
}
