import '../utils/request.dart';

/// 歌曲详情
Future<Map<String, dynamic>> songDetail(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final ids = query['ids'].toString().split(RegExp(r'\s*,\s*'));
  final data = {
    'c': '[${ids.map((id) => '{"id":$id}').join(',')}]',
  };

  return await request(
      '/api/v3/song/detail', data, RequestOptions.create(query, crypto: 'api'));
}
