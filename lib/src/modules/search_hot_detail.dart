import '../utils/request.dart';

/// 热搜列表
/// 获取热门搜索关键词列表及其详细信息
Future<Map<String, dynamic>> searchHotDetail(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = <String, dynamic>{};
  
  return await request(
      '/api/hotsearchlist/get', data, RequestOptions.create(query, crypto: 'weapi'));
}
