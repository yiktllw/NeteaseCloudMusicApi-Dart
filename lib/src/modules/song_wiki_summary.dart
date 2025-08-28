import '../utils/request.dart';

/// 音乐百科基础信息
Future<Map<String, dynamic>> songWikiSummary(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = {
    'songId': query['id'],
  };

  return await request(
      '/api/song/play/about/block/page', data, RequestOptions.create(query));
}
