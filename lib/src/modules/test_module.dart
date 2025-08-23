import '../utils/request.dart';

/// 测试模块 - 验证自动注册功能
Future<Map<String, dynamic>> testFunction({String? cookie}) async {
  final data = <String, dynamic>{
    'test': 'data',
  };

  return {
    'success': true,
    'message': '自动注册功能测试成功',
    'data': data,
  };
}

/// 另一个测试函数
Future<Map<String, dynamic>> anotherTestFunction({required String id, String? cookie}) async {
  return {
    'success': true,
    'id': id,
    'message': '第二个测试函数',
  };
}
