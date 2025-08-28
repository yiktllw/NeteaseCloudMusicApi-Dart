import '../utils/request.dart';

/// 退出登录
Future<Map<String, dynamic>> logout(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  return await request(
    '/api/logout',
    <String, dynamic>{},
    RequestOptions.create(query),
  );
}
