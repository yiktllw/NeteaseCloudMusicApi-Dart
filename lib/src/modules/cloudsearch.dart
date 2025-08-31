import '../utils/request.dart';

/// 云搜索
/// 更全面的搜索接口，支持多种类型的搜索
/// 
/// [query] 参数：
/// - keywords: 搜索关键词
/// - type: 搜索类型
///   * 1: 单曲
///   * 10: 专辑
///   * 100: 歌手
///   * 1000: 歌单
///   * 1002: 用户
///   * 1004: MV
///   * 1006: 歌词
///   * 1009: 电台
///   * 1014: 视频
/// - limit: 返回数量限制，默认30
/// - offset: 偏移量，默认0
Future<Map<String, dynamic>> cloudsearch(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = {
    's': query['keywords'],
    'type': query['type'] ?? 1, // 默认搜索单曲
    'limit': query['limit'] ?? 30,
    'offset': query['offset'] ?? 0,
    'total': true,
  };
  
  return await request(
      '/api/cloudsearch/pc', data, RequestOptions.create(query));
}
