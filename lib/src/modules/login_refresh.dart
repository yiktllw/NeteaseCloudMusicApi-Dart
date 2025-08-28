import '../utils/request.dart';

/// 登录刷新
Future<Map<String, dynamic>> loginRefresh(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final result = await request(
    '/api/login/token/refresh',
    <String, dynamic>{},
    RequestOptions.create(query),
  );

  if (result['body']['code'] == 200) {
    return {
      'status': 200,
      'body': <String, dynamic>{
        ...result['body'] as Map<String, dynamic>,
        'cookie': (result['cookie'] as List).join(';'),
      },
      'cookie': result['cookie'],
    };
  }

  return result;
}
