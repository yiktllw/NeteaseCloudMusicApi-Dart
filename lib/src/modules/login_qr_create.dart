import '../utils/request.dart';
import '../utils/module_registry.dart';

/// 二维码登录创建
Future<Map<String, dynamic>> loginQrCreate(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(String, Map<String, dynamic>, RequestOptions) request,
) async {
  final url = 'https://music.163.com/login?codekey=${query['key']}';
  
  return {
    'code': 200,
    'status': 200,
    'body': {
      'code': 200,
      'data': {
        'qrurl': url,
        'qrimg': query['qrimg'] == true || query['qrimg'] == 'true' ? url : '',
      },
    },
  };
}

/// 注册二维码登录创建模块
void registerLoginQrCreateModule() {
  ModuleRegistry.register('loginQrCreate', loginQrCreate);
}