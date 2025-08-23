import '../utils/request.dart';

/// 歌单详情
Future<Map<String, dynamic>> playlistDetail(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(String, Map<String, dynamic>, RequestOptions) request,
) async {
  final data = {
    'id': query['id'],
    'n': '100000',
    's': query['s'] ?? '8',
  };

  return await request('/api/v6/playlist/detail', data, RequestOptions.create(query));
}
