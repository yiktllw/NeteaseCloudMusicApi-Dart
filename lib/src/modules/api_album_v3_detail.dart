import '../utils/request.dart';
import '../utils/cache_key.dart';

/// 手机端的专辑详情页
Future<Map<String, dynamic>> apiAlbumV3Detail(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = {
    'id': query['id'],
    'cache_key': generateCacheKey(query['id'].toString()),
    'header': '',
  };

  // 使用EAPI加密，设置e_r为true启用响应解密
  return await request('/api/album/v3/detail', data,
      RequestOptions(crypto: 'eapi', eR: true));
}
