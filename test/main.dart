// ignore_for_file: avoid_print

import 'package:netease_cloud_music_api/src/netease_cloud_music_api_final.dart';
import 'dart:io';
import 'dart:convert';

// 全局变量存储历史记录和用户变量
List<ApiTestRecord> testHistory = [];
Map<String, String> userVariables = {};

void main() async {
  print('=== 网易云音乐API Dart版本 - 交互式测试工具 ===\n');

  // 创建API实例
  final api = NeteaseCloudMusicApiFinal();

  // 读取cookie
  String? cookie = await loadCookie();

  // 加载历史记录和用户变量
  await loadTestHistory();
  await loadUserVariables();

  // 获取所有可用的API
  final apiInfo = getApiInfo();

  while (true) {
    try {
      // 显示主菜单
      print('\n📋 主菜单:');
      print('   1. 测试API');
      print('   2. 管理变量 (${userVariables.length}个)');
      print('   3. 查看历史记录 (${testHistory.length}个)');
      print('   4. 退出');
      print('\n请选择操作 (1-4):');
      stdout.write('> ');
      
      final choice = stdin.readLineSync()?.trim() ?? '';
      
      switch (choice) {
        case '1':
          await testApi(api, apiInfo, cookie);
          break;
        case '2':
          await manageVariables();
          break;
        case '3':
          await viewHistory();
          break;
        case '4':
        case 'exit':
          print('👋 再见！');
          return;
        default:
          print('❌ 无效选择，请输入1-4');
      }

    } catch (e, stackTrace) {
      print('❌ 发生错误: $e');
      print('📍 堆栈跟踪: $stackTrace');
      print('\n🔄 继续...\n');
    }
  }
}

/// 测试API主流程
Future<void> testApi(NeteaseCloudMusicApiFinal api, Map<String, Map<String, ParameterInfo>> apiInfo, String? cookie) async {
  // 1. 让用户选择API（支持搜索和补全）
  final selectedApi = await selectApi(apiInfo);
  if (selectedApi == null) {
    return;
  }

  print('\n✅ 已选择API: $selectedApi');
  
  // 2. 获取API参数信息
  final paramInfo = getApiParameters(selectedApi);
  
  // 3. 让用户输入参数
  final params = await collectParameters(paramInfo, cookie, selectedApi);
  if (params == null) {
    return;
  }

  // 4. 调用API
  print('\n🚀 正在调用API: $selectedApi');
  print('=' * 60);

  final startTime = DateTime.now();
  final result = await api.call(selectedApi, params);
  final endTime = DateTime.now();
  final duration = endTime.difference(startTime);

  // 5. 显示结果
  print('⏱️ 请求耗时: ${duration.inMilliseconds}ms');
  print('📊 响应结果:');
  print('=' * 60);
  
  final formattedResult = formatJsonOutput(result);
  print(formattedResult);
  
  print('=' * 60);
  
  // 6. 保存到历史记录
  await saveToHistory(selectedApi, params, duration.inMilliseconds, result);

  print('\n✅ 已保存到历史记录');
}

/// 获取API信息（硬编码，基于api_constants.dart）
Map<String, Map<String, ParameterInfo>> getApiInfo() {
  return {
    'albumSublist': {
      'limit': ParameterInfo(name: 'limit', isRequired: false, type: 'int', description: '限制返回数量'),
      'offset': ParameterInfo(name: 'offset', isRequired: false, type: 'int', description: '偏移量'),
    },
    'loginQrCheck': {
      'key': ParameterInfo(name: 'key', isRequired: true, type: 'String', description: '二维码key'),
    },
    'loginQrCreate': {
      'key': ParameterInfo(name: 'key', isRequired: true, type: 'String', description: '二维码key'),
      'qrimg': ParameterInfo(name: 'qrimg', isRequired: true, type: 'String', description: '是否返回二维码图片'),
    },
    'loginQrKey': {},
    'loginRefresh': {},
    'loginStatus': {},
    'logout': {},
    'personalized': {
      'limit': ParameterInfo(name: 'limit', isRequired: false, type: 'int', description: '限制返回数量'),
    },
    'playlistDetail': {
      'id': ParameterInfo(name: 'id', isRequired: true, type: 'String', description: '歌单ID'),
      's': ParameterInfo(name: 's', isRequired: false, type: 'String', description: '歌单最近收藏者'),
    },
    'playlistTrackAll': {
      'id': ParameterInfo(name: 'id', isRequired: true, type: 'String', description: '歌单ID'),
      's': ParameterInfo(name: 's', isRequired: false, type: 'String', description: '歌单最近收藏者'),
      'limit': ParameterInfo(name: 'limit', isRequired: false, type: 'int', description: '限制返回数量'),
      'offset': ParameterInfo(name: 'offset', isRequired: false, type: 'int', description: '偏移量'),
    },
    'recommendSongs': {},
    'search': {
      'type': ParameterInfo(name: 'type', isRequired: false, type: 'int', description: '搜索类型 1:单曲 10:专辑 100:歌手 1000:歌单'),
      'keywords': ParameterInfo(name: 'keywords', isRequired: true, type: 'String', description: '搜索关键词'),
      'limit': ParameterInfo(name: 'limit', isRequired: false, type: 'int', description: '限制返回数量'),
      'offset': ParameterInfo(name: 'offset', isRequired: false, type: 'int', description: '偏移量'),
    },
    'songDetail': {
      'ids': ParameterInfo(name: 'ids', isRequired: true, type: 'String', description: '歌曲ID，多个用逗号分隔'),
    },
    'songUrlV1': {
      'id': ParameterInfo(name: 'id', isRequired: true, type: 'String', description: '歌曲ID'),
      'level': ParameterInfo(name: 'level', isRequired: true, type: 'String', description: '音质等级 standard/exhigh/lossless'),
    },
    'songWikiSummary': {
      'id': ParameterInfo(name: 'id', isRequired: true, type: 'String', description: '歌曲ID'),
    },
    'userAccount': {},
    'userDetail': {
      'uid': ParameterInfo(name: 'uid', isRequired: true, type: 'String', description: '用户ID'),
    },
    'userPlaylist': {
      'uid': ParameterInfo(name: 'uid', isRequired: false, type: 'String', description: '用户ID'),
      'limit': ParameterInfo(name: 'limit', isRequired: false, type: 'int', description: '限制返回数量'),
      'offset': ParameterInfo(name: 'offset', isRequired: false, type: 'int', description: '偏移量'),
    },
    'userRecord': {
      'uid': ParameterInfo(name: 'uid', isRequired: false, type: 'String', description: '用户ID'),
      'type': ParameterInfo(name: 'type', isRequired: false, type: 'int', description: '记录类型 1:最近一周 0:所有时间'),
    },
  };
}

/// 选择API（支持搜索）
Future<String?> selectApi(Map<String, Map<String, ParameterInfo>> apiInfo) async {
  final apis = apiInfo.keys.toList()..sort();
  
  print('\n📋 可用的API模块 (${apis.length}个):');
  
  while (true) {
    print('\n🔍 请输入API名称进行搜索 (输入部分名称即可，输入"list"查看所有API，"back"返回):');
    stdout.write('> ');
    final input = stdin.readLineSync()?.trim() ?? '';

    if (input.toLowerCase() == 'back') {
      return null;
    }

    if (input.toLowerCase() == 'list') {
      _displayApiList(apis);
      continue;
    }

    if (input.isEmpty) {
      print('❌ 请输入API名称');
      continue;
    }

    // 查找匹配的API
    final matches = findMatchingApis(apis, input);
    
    if (matches.isEmpty) {
      print('❌ 未找到匹配的API');
      _showSuggestions(apis, input);
      continue;
    }

    if (matches.length == 1) {
      return matches.first;
    }

    // 多个匹配，让用户选择
    print('\n🔍 找到 ${matches.length} 个匹配的API:');
    for (int i = 0; i < matches.length; i++) {
      print('   ${i + 1}: ${matches[i]}');
    }
    print('请选择序号 (1-${matches.length}):');
    stdout.write('> ');
    
    final selection = int.tryParse(stdin.readLineSync()?.trim() ?? '');
    if (selection != null && selection >= 1 && selection <= matches.length) {
      return matches[selection - 1];
    } else {
      print('❌ 无效的选择');
    }
  }
}

/// 显示API列表
void _displayApiList(List<String> apis) {
  print('\n📋 所有可用的API:');
  for (int i = 0; i < apis.length; i++) {
    print('   ${(i + 1).toString().padLeft(3)}: ${apis[i]}');
  }
}

/// 显示建议
void _showSuggestions(List<String> apis, String input) {
  final suggestions = apis.where((api) => 
    api.toLowerCase().contains(input.toLowerCase())
  ).take(5).toList();
  
  if (suggestions.isNotEmpty) {
    print('💡 相似的API建议:');
    for (var api in suggestions) {
      print('   - $api');
    }
  }
}

/// 获取API参数信息
Map<String, ParameterInfo> getApiParameters(String apiName) {
  final apiInfo = getApiInfo();
  return apiInfo[apiName] ?? <String, ParameterInfo>{};
}

/// 收集用户输入的参数
Future<Map<String, dynamic>?> collectParameters(
  Map<String, ParameterInfo> paramInfo, 
  String? cookie,
  String apiName,
) async {
  print('\n📝 参数输入选项:');
  print('   1. 手动输入参数');
  print('   2. 从历史记录选择');
  print('   3. 返回');
  
  stdout.write('请选择 (1-3): ');
  final choice = stdin.readLineSync()?.trim() ?? '';
  
  switch (choice) {
    case '1':
      return await _collectParametersManually(paramInfo, cookie);
    case '2':
      return await _selectFromHistory(apiName, paramInfo, cookie);
    case '3':
      return null;
    default:
      print('❌ 无效选择');
      return null;
  }
}

/// 手动输入参数
Future<Map<String, dynamic>> _collectParametersManually(
  Map<String, ParameterInfo> paramInfo, 
  String? cookie,
) async {
  final params = <String, dynamic>{};
  
  if (paramInfo.isEmpty) {
    print('📝 此API无需额外参数');
  } else {
    print('\n📝 请输入API参数 (输入变量名 \$varname 来使用保存的变量):');
    
    for (final entry in paramInfo.entries) {
      final paramName = entry.key;
      final info = entry.value;
      
      while (true) {
        final requiredText = info.isRequired ? ' (必填)' : ' (可选)';
        final typeText = info.type != 'dynamic' ? ' [${info.type}]' : '';
        final descText = info.description?.isNotEmpty == true ? ' - ${info.description}' : '';
        
        // 为一些参数提供示例值
        final example = getParameterExample(paramName, info.type);
        final exampleText = example.isNotEmpty ? ' 例如: $example' : '';
        
        print('   $paramName$requiredText$typeText$descText$exampleText:');
        
        // 显示可用变量提示
        if (userVariables.isNotEmpty) {
          final relevantVars = userVariables.entries.where((e) => 
            e.key.toLowerCase().contains(paramName.toLowerCase()) ||
            paramName.toLowerCase().contains(e.key.toLowerCase())
          ).take(3);
          
          if (relevantVars.isNotEmpty) {
            print('   💡 相关变量: ${relevantVars.map((e) => '\$${e.key}=${e.value}').join(', ')}');
          }
        }
        
        stdout.write('   > ');
        final input = stdin.readLineSync()?.trim() ?? '';
        
        if (input.isEmpty) {
          if (info.isRequired) {
            print('   ❌ 此参数为必填项，请输入值');
            continue;
          } else {
            break; // 可选参数跳过
          }
        }
        
        // 处理变量替换
        final processedInput = processVariables(input);
        
        // 类型转换
        final value = convertValue(processedInput, info.type);
        if (value != null) {
          params[paramName] = value;
          break;
        } else {
          print('   ❌ 输入格式错误，请重新输入');
        }
      }
    }
  }
  
  // 询问是否使用cookie
  if (cookie != null && cookie.isNotEmpty) {
    print('\n🍪 是否使用cookie? (y/n, 默认n):');
    stdout.write('> ');
    final cookieChoice = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    if (cookieChoice == 'y' || cookieChoice == 'yes') {
      params['cookie'] = cookie;
      print('✅ 已添加cookie');
    }
  }
  
  // 自动添加timestamp
  params['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
  
  return params;
}

/// 从历史记录选择参数
Future<Map<String, dynamic>?> _selectFromHistory(
  String apiName,
  Map<String, ParameterInfo> paramInfo,
  String? cookie,
) async {
  final relevantHistory = testHistory.where((record) => 
    record.apiName == apiName
  ).toList();
  
  if (relevantHistory.isEmpty) {
    print('❌ 没有找到 $apiName 的历史记录');
    return await _collectParametersManually(paramInfo, cookie);
  }
  
  print('\n📚 $apiName 的历史记录:');
  for (int i = 0; i < relevantHistory.length; i++) {
    final record = relevantHistory[i];
    final paramsPreview = jsonEncode(record.parameters).length > 50 
        ? '${jsonEncode(record.parameters).substring(0, 50)}...'
        : jsonEncode(record.parameters);
    print('   ${i + 1}: ${record.timestamp} - $paramsPreview');
  }
  print('   ${relevantHistory.length + 1}: 手动输入新参数');
  
  stdout.write('请选择历史记录 (1-${relevantHistory.length + 1}): ');
  final selection = int.tryParse(stdin.readLineSync()?.trim() ?? '');
  
  if (selection == null || selection < 1 || selection > relevantHistory.length + 1) {
    print('❌ 无效选择');
    return null;
  }
  
  if (selection == relevantHistory.length + 1) {
    return await _collectParametersManually(paramInfo, cookie);
  }
  
  final selectedRecord = relevantHistory[selection - 1];
  print('✅ 已选择历史记录: ${selectedRecord.timestamp}');
  print('📝 参数: ${jsonEncode(selectedRecord.parameters)}');
  
  // 询问是否修改参数
  print('\n是否要修改参数? (y/n, 默认n):');
  stdout.write('> ');
  final modifyChoice = stdin.readLineSync()?.trim().toLowerCase() ?? '';
  
  if (modifyChoice == 'y' || modifyChoice == 'yes') {
    return await _modifyParameters(Map<String, dynamic>.from(selectedRecord.parameters), paramInfo, cookie);
  }
  
  return Map<String, dynamic>.from(selectedRecord.parameters);
}

/// 修改现有参数
Future<Map<String, dynamic>> _modifyParameters(
  Map<String, dynamic> existingParams,
  Map<String, ParameterInfo> paramInfo,
  String? cookie,
) async {
  final params = Map<String, dynamic>.from(existingParams);
  
  print('\n📝 修改参数 (直接回车保持原值):');
  
  for (final entry in paramInfo.entries) {
    final paramName = entry.key;
    final info = entry.value;
    final currentValue = params[paramName];
    
    print('   $paramName [${info.type}] 当前值: $currentValue');
    stdout.write('   新值: ');
    final input = stdin.readLineSync()?.trim() ?? '';
    
    if (input.isNotEmpty) {
      final processedInput = processVariables(input);
      final value = convertValue(processedInput, info.type);
      if (value != null) {
        params[paramName] = value;
      } else {
        print('   ❌ 输入格式错误，保持原值');
      }
    }
  }
  
  return params;
}

/// 处理变量替换
String processVariables(String input) {
  String result = input;
  final regex = RegExp(r'\$(\w+)');
  final matches = regex.allMatches(input);
  
  for (final match in matches) {
    final varName = match.group(1);
    if (varName != null && userVariables.containsKey(varName)) {
      result = result.replaceAll('\$$varName', userVariables[varName]!);
    }
  }
  
  return result;
}

/// 管理用户变量
Future<void> manageVariables() async {
  while (true) {
    print('\n🔧 变量管理:');
    print('   1. 查看所有变量 (${userVariables.length}个)');
    print('   2. 添加/修改变量');
    print('   3. 删除变量');
    print('   4. 返回主菜单');
    
    stdout.write('请选择 (1-4): ');
    final choice = stdin.readLineSync()?.trim() ?? '';
    
    switch (choice) {
      case '1':
        _displayVariables();
        break;
      case '2':
        await _addOrModifyVariable();
        break;
      case '3':
        await _deleteVariable();
        break;
      case '4':
        return;
      default:
        print('❌ 无效选择');
    }
  }
}

/// 显示所有变量
void _displayVariables() {
  if (userVariables.isEmpty) {
    print('\n📝 暂无保存的变量');
    return;
  }
  
  print('\n📝 保存的变量:');
  userVariables.forEach((key, value) {
    print('   \$$key = $value');
  });
}

/// 添加或修改变量
Future<void> _addOrModifyVariable() async {
  print('\n➕ 添加/修改变量:');
  stdout.write('变量名: ');
  final name = stdin.readLineSync()?.trim() ?? '';
  
  if (name.isEmpty) {
    print('❌ 变量名不能为空');
    return;
  }
  
  stdout.write('变量值: ');
  final value = stdin.readLineSync()?.trim() ?? '';
  
  if (value.isEmpty) {
    print('❌ 变量值不能为空');
    return;
  }
  
  userVariables[name] = value;
  await saveUserVariables();
  print('✅ 变量 \$$name 已保存');
}

/// 删除变量
Future<void> _deleteVariable() async {
  if (userVariables.isEmpty) {
    print('📝 暂无变量可删除');
    return;
  }
  
  print('\n🗑️ 选择要删除的变量:');
  final keys = userVariables.keys.toList();
  for (int i = 0; i < keys.length; i++) {
    print('   ${i + 1}: \$${keys[i]} = ${userVariables[keys[i]]}');
  }
  
  stdout.write('请选择序号 (1-${keys.length}): ');
  final selection = int.tryParse(stdin.readLineSync()?.trim() ?? '');
  
  if (selection == null || selection < 1 || selection > keys.length) {
    print('❌ 无效选择');
    return;
  }
  
  final key = keys[selection - 1];
  userVariables.remove(key);
  await saveUserVariables();
  print('✅ 变量 \$$key 已删除');
}

/// 查看历史记录
Future<void> viewHistory() async {
  if (testHistory.isEmpty) {
    print('\n📚 暂无历史记录');
    return;
  }
  
  print('\n📚 测试历史记录:');
  for (int i = 0; i < testHistory.length; i++) {
    final record = testHistory[i];
    print('   ${i + 1}: ${record.timestamp} - ${record.apiName} (${record.duration}ms)');
  }
  
  print('\n操作选项:');
  print('   1. 查看详细记录');
  print('   2. 清空历史记录');
  print('   3. 返回');
  
  stdout.write('请选择 (1-3): ');
  final choice = stdin.readLineSync()?.trim() ?? '';
  
  switch (choice) {
    case '1':
      await _viewDetailedHistory();
      break;
    case '2':
      await _clearHistory();
      break;
    case '3':
      return;
  }
}

/// 查看详细历史记录
Future<void> _viewDetailedHistory() async {
  print('\n请选择要查看的记录序号 (1-${testHistory.length}):');
  stdout.write('> ');
  final selection = int.tryParse(stdin.readLineSync()?.trim() ?? '');
  
  if (selection == null || selection < 1 || selection > testHistory.length) {
    print('❌ 无效选择');
    return;
  }
  
  final record = testHistory[selection - 1];
  print('\n📋 详细记录:');
  print('   时间: ${record.timestamp}');
  print('   API: ${record.apiName}');
  print('   耗时: ${record.duration}ms');
  print('   参数: ${formatJsonOutput(record.parameters)}');
}

/// 清空历史记录
Future<void> _clearHistory() async {
  print('\n⚠️ 确定要清空所有历史记录吗? (y/n):');
  stdout.write('> ');
  final confirm = stdin.readLineSync()?.trim().toLowerCase() ?? '';
  
  if (confirm == 'y' || confirm == 'yes') {
    testHistory.clear();
    await saveTestHistory();
    print('✅ 历史记录已清空');
  }
}

/// 保存到历史记录
Future<void> saveToHistory(String apiName, Map<String, dynamic> parameters, int duration, Map<String, dynamic> response) async {
  final record = ApiTestRecord(
    apiName: apiName,
    parameters: Map<String, dynamic>.from(parameters),
    timestamp: DateTime.now().toString().substring(0, 19),
    duration: duration,
    response: Map<String, dynamic>.from(response),
  );
  
  testHistory.insert(0, record);
  
  // 保持最多10条记录
  if (testHistory.length > 10) {
    testHistory = testHistory.take(10).toList();
  }
  
  await saveTestHistory();
}

/// 加载历史记录
Future<void> loadTestHistory() async {
  try {
    final file = File('test_history.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(content);
      testHistory = jsonData.map((item) => ApiTestRecord.fromJson(item)).toList();
      print('📚 已加载 ${testHistory.length} 条历史记录');
    }
  } catch (e) {
    print('⚠️ 加载历史记录失败: $e');
  }
}

/// 保存历史记录
Future<void> saveTestHistory() async {
  try {
    final file = File('test_history.json');
    final jsonData = testHistory.map((record) => record.toJson()).toList();
    const encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(jsonData));
  } catch (e) {
    print('⚠️ 保存历史记录失败: $e');
  }
}

/// 加载用户变量
Future<void> loadUserVariables() async {
  try {
    final file = File('user_variables.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final Map<String, dynamic> jsonData = jsonDecode(content);
      userVariables = jsonData.cast<String, String>();
      print('🔧 已加载 ${userVariables.length} 个用户变量');
    }
  } catch (e) {
    print('⚠️ 加载用户变量失败: $e');
  }
}

/// 保存用户变量
Future<void> saveUserVariables() async {
  try {
    final file = File('user_variables.json');
    const encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(userVariables));
  } catch (e) {
    print('⚠️ 保存用户变量失败: $e');
  }
}

/// 获取参数示例值
String getParameterExample(String paramName, String type) {
  switch (paramName.toLowerCase()) {
    case 'id':
    case 'uid':
      return '1145545';
    case 'ids':
      return '1145545,2145545';
    case 'keywords':
      return '周杰伦';
    case 'level':
      return 'standard';
    case 'limit':
      return '20';
    case 'offset':
      return '0';
    case 'type':
      return '1';
    case 'key':
      return 'qr_key_12345';
    case 'qrimg':
      return 'true';
    default:
      return '';
  }
}

/// 值类型转换
dynamic convertValue(String input, String type) {
  try {
    switch (type.toLowerCase()) {
      case 'int':
        return int.parse(input);
      case 'double':
        return double.parse(input);
      case 'bool':
        return input.toLowerCase() == 'true' || input == '1';
      case 'string':
      default:
        return input;
    }
  } catch (e) {
    return null;
  }
}

/// API测试记录类
class ApiTestRecord {
  final String apiName;
  final Map<String, dynamic> parameters;
  final String timestamp;
  final int duration;
  final Map<String, dynamic> response;
  
  ApiTestRecord({
    required this.apiName,
    required this.parameters,
    required this.timestamp,
    required this.duration,
    required this.response,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'apiName': apiName,
      'parameters': parameters,
      'timestamp': timestamp,
      'duration': duration,
      'response': response,
    };
  }
  
  factory ApiTestRecord.fromJson(Map<String, dynamic> json) {
    return ApiTestRecord(
      apiName: json['apiName'],
      parameters: Map<String, dynamic>.from(json['parameters']),
      timestamp: json['timestamp'],
      duration: json['duration'],
      response: Map<String, dynamic>.from(json['response']),
    );
  }
}

/// 参数信息类
class ParameterInfo {
  final String name;
  final bool isRequired;
  final String type;
  final String? description;
  
  ParameterInfo({
    required this.name,
    required this.isRequired,
    required this.type,
    this.description,
  });
}

/// 加载cookie文件
Future<String?> loadCookie() async {
  try {
    final cookieFile = File('cookie.txt');
    if (await cookieFile.exists()) {
      final cookie = await cookieFile.readAsString();
      print('🍪 已加载cookie文件 (${cookie.length}字符)');
      return cookie.trim();
    } else {
      print('⚠️ 未找到cookie.txt文件');
      return null;
    }
  } catch (e) {
    print('❌ 无法读取cookie文件: $e');
    return null;
  }
}

/// 查找匹配的API
List<String> findMatchingApis(List<String> apis, String input) {
  final lowerInput = input.toLowerCase();
  
  // 精确匹配
  final exactMatches = apis.where((api) => 
    api.toLowerCase() == lowerInput
  ).toList();
  
  if (exactMatches.isNotEmpty) {
    return exactMatches;
  }
  
  // 前缀匹配
  final prefixMatches = apis.where((api) => 
    api.toLowerCase().startsWith(lowerInput)
  ).toList();
  
  if (prefixMatches.isNotEmpty) {
    return prefixMatches;
  }
  
  // 包含匹配
  final containsMatches = apis.where((api) => 
    api.toLowerCase().contains(lowerInput)
  ).toList();
  
  return containsMatches;
}

/// 格式化JSON输出，使其易于阅读
String formatJsonOutput(dynamic data) {
  try {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  } catch (e) {
    return data.toString();
  }
}
