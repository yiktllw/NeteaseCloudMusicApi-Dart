import '../utils/request.dart';

/// 喜欢的歌曲(无序)
///
/// [query] 查询参数
/// - uid: 用户 ID (必需)
///
/// 返回用户喜欢的歌曲列表
Future<Map<String, dynamic>> likelist(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final uid = query['uid'];
  if (uid == null) {
    throw ArgumentError('Missing required parameter: uid');
  }

  final data = {
    'uid': uid,
  };

  return await request('/api/song/like/get', data,
      RequestOptions.create(query, crypto: 'weapi'));
}
