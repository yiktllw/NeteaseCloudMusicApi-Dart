import '../utils/request.dart';

/// 搜索建议
/// 根据输入的关键词获取搜索建议
/// 
/// [query] 参数：
/// - keywords: 搜索关键词
/// - type: 设备类型，'mobile' 或其他（默认为web）
Future<Map<String, dynamic>> searchSuggest(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = {
    's': query['keywords'] ?? '',
  };
  
  // 根据类型选择接口路径
  String type = query['type'] == 'mobile' ? 'keyword' : 'web';
  
  return await request(
      '/api/search/suggest/$type', data, RequestOptions.create(query, crypto: 'weapi'));
}
