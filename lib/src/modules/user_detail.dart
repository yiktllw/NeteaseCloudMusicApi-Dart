import 'dart:convert';
import '../utils/request.dart';

/// 用户详情
Future<Map<String, dynamic>> userDetail(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = <String, dynamic>{};
  final response = await request('/api/v1/user/detail/${query['uid']}', data,
      RequestOptions.create(query, crypto: 'weapi'));

  // 参考原项目，处理 avatarImgId_str 字段
  final responseStr = jsonEncode(response);
  final processedStr =
      responseStr.replaceAll('avatarImgId_str', 'avatarImgIdStr');
  return jsonDecode(processedStr) as Map<String, dynamic>;
}
