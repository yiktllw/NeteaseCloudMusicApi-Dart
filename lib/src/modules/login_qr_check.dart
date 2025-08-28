import '../utils/request.dart';

/// 二维码登录检测
Future<Map<String, dynamic>> loginQrCheck(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = <String, dynamic>{
    'key': query['key'],
    'type': 3,
  };

  try {
    final result = await request(
      '/api/login/qrcode/client/login',
      data,
      RequestOptions.create(query),
    );

    return {
      'status': 200,
      'body': <String, dynamic>{
        ...result['body'] as Map<String, dynamic>,
        'cookie': (result['cookie'] as List).join(';'),
      },
      'cookie': result['cookie'],
    };
  } catch (error) {
    return {
      'status': 200,
      'body': <String, dynamic>{},
      'cookie': <String>[],
    };
  }
}
