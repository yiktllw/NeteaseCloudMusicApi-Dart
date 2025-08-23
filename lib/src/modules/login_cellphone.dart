import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../utils/request.dart';
import '../utils/module_registry.dart';

/// 手机登录
Future<Map<String, dynamic>> loginCellphone(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(String, Map<String, dynamic>, RequestOptions) request,
) async {
  final data = {
    'type': '1',
    'https': 'true',
    'phone': query['phone'],
    'countrycode': query['countrycode'] ?? '86',
    'captcha': query['captcha'],
  };

  // 处理密码
  if (query['captcha'] != null) {
    data['captcha'] = query['captcha'];
  } else {
    final password = query['md5_password'] ?? 
        md5.convert(utf8.encode(query['password'] ?? '')).toString();
    data['password'] = password;
  }

  data['rememberLogin'] = 'true';

  final result = await request(
    '/api/w/login/cellphone',
    data,
    RequestOptions.create(query),
  );

  if (result['status'] == 200 && result['body']['code'] == 200) {
    // 处理返回结果
    final body = result['body'];
    final responseBodyStr = jsonEncode(body);
    final processedBodyStr = responseBodyStr.replaceAll('avatarImgId_str', 'avatarImgIdStr');
    final processedBody = jsonDecode(processedBodyStr);
    
    return {
      'status': 200,
      'body': {
        ...processedBody,
        'cookie': result['cookie'].join(';'),
      },
      'cookie': result['cookie'],
    };
  }

  return result;
}

/// 注册手机登录模块
void registerLoginCellphoneModule() {
  ModuleRegistry.register('loginCellphone', loginCellphone);
}