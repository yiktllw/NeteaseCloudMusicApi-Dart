import '../utils/request.dart';

/// 登录状态
Future<Map<String, dynamic>> loginStatus(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = <String, dynamic>{};

  final result = await request(
    '/api/w/nuser/account/get',
    data,
    RequestOptions.create(query, crypto: 'weapi'),
  );

  if (result['body']['code'] == 200) {
    return {
      'status': 200,
      'body': {
        'data': <String, dynamic>{
          ...result['body'] as Map<String, dynamic>,
        },
      },
      'cookie': result['cookie'],
    };
  }

  return result;
}
