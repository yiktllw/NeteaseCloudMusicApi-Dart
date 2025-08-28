import '../utils/request.dart';

/// 二维码登录 key 生成
Future<Map<String, dynamic>> loginQrKey(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = <String, dynamic>{
    'type': 3,
  };

  final result = await request(
    '/api/login/qrcode/unikey',
    data,
    RequestOptions.create(query),
  );

  return {
    'status': 200,
    'body': {
      'data': result['body'],
      'code': 200,
    },
    'cookie': result['cookie'],
  };
}
